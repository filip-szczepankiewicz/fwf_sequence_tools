function [gwf, t, x] = optimize(dur, tp, gmax, smax, hw, opt)
% function [gwf, t, x] = dime.optimize(dur, tp, gmax, smax, hw, opt)
% By Filip Szczepankiewicz, Lund University
%
%   Designs an diffusion-encoding gradient waveform (GWF) that yields
%   spherical b-tensor encoding, and its 1D projection is a matched linear
%   b-tensor encoding variant. The optimizer maximizes the
%   diffusion weighting (b-value) for a fixed timing budget, while enforcing
%   gradient hardware limits, double isotropic encoding, and (optionally)
%   peripheral nerve stimulation (PNS) limits using SAFE PNS prediction.
%
%   The optimization is performed with FMINCON, optionally wrapped in
%   GlobalSearch or MultiStart (see opt.optMode).
%
%   Inputs
%   ------
%   dur  - Duration [ms] of available encoding time on each side of the
%          refocusing pulse.
%   tp   - Pause [ms] between the end of the first and the start of the second
%          lobe (e.g., crusher/spacing + refocusing pulse).
%   gmax - Maximum gradient amplitude [T/m].
%   smax - Maximum slew rate [T/m/s].
%   mode - Cost/constraint mode for stimulation:
%          0 disables PNS constraints; 1–7 enable different PNS metrics
%          (see gwf2pnsCost for definitions).
%   hw   - SAFE hardware model struct array used for PNS and CNS prediction
%          (see safe_* functions; e.g. safe_example_hw_peripheral). Requires
%          https://github.com/filip-szczepankiewicz/safe_pns_prediction
%   opt  - Options struct for the optimizer and constraint tolerances.
%          Default is created by opt = dime.options(gmax, smax, dur).
%          opt.optMode = 0, 1, or 2 allows selection between:
%          0: Single optimization with fmincon
%          1: GlobalSearch with fmincon
%          2: MultiStart with fmincon (default)
%
%   Outputs
%   -------
%   gwf  - Optimized gradient waveform [T/m], size [n x 3]. Note that this
%          waveform only includes the optimizer control points. To get a
%          useful waveforms please call ii_gwf2gwfi(gwf, t, dt)
%   t    - Time points for gwf [ms]. These are unique per axis!
%   x    - Optimized parameter vector:
%          x(1) alpha      Fractional amplitude of x/y vs z
%          x(2) beta       Fraction of encoding time dedicated to x/y
%          x(3) rampUpXY   Ramp-up time for x/y gradients
%          x(4) rampDownXY Ramp-down time for x/y gradients
%          x(5) rampUpZ    Ramp-up time for z gradient
%          x(6) rampDownZ  Ramp-down time for z gradient
%          x(7) gampGlo    Global amplitude scale
%
%   Constraints enforced
%   --------------------
%   - b-tensor and m-tensor anisotropy tolerances (opt.tol_bAniso, opt.tol_mAniso)
%   - Optional stimulation constraints: max(PNS) / L2-norm / LTE worst-case variants
%     depending on MODE, with tolerance opt.tol_stim (via SAFE prediction).

if nargin < 1
    dur  = 40; % ms
    tp   = 6;  % ms
    gmax = 0.08; % T/m
    smax = 200;  % T/m/s

    opt = dime.options(gmax, smax, dur);
    hw  = safe_example_hw_peripheral;

    [gwf, t] = dime.optimize(dur, tp, gmax, smax, hw, opt);

    [gwf, rf, dt] = dime.convert.ana2num(gwf, t/1000, 0.1e-3);

    clf
    dime.plot.gwfSetAndStim(gwf, rf, dt, hw);
    return
end

if nargin < 6
    opt = dime.options(gmax, smax, dur);
end

% Check that problem is reasonable
assert(sum(opt.lb([3 3 4 4 5 6]))<dur, 'Shortest ramps do not fit in duration! Dur must be longer!')
assert(sum(opt.ub([3 3 4 4 5 6]))<dur, 'Longest ramps do not fit in duration! Consider extending dur or shortening the max ramp times.')


problem = createOptimProblem('fmincon',...
    'objective', @this_cost,...
    'x0', opt.x0,...
    'lb', opt.lb,...
    'ub', opt.ub,...
    'nonlcon', @this_nlcon,...
    'options', opt.fmc);


switch opt.optMode
    case 0 % Single solve, works in simple setups
        x = fmincon(problem);

    case 1 % Global solver
        x = run(GlobalSearch('NumTrialPoints', opt.numTrialPts, 'NumStageOnePoints', opt.numInitialPts), problem);

    case 2 % Multistart solver
        x = run(MultiStart('UseParallel', true), problem, opt.numStartPts);
end


% Unpack once for your final call
% alpha       = x(1); % Fractional amplitude of xy gradient compared to z
% beta        = x(2); % Fraction of flat top time dedicated to xy gradients
% rampUpXY    = x(3); % Ramp up time for xy-gradient
% rampDownXY  = x(4); % Ramp down time for xy-gradient
% rampUpZ     = x(5); % Ramp up time for z-gradient
% rampDownZ   = x(6); % Ramp down time for z-gradient
% gampGlo     = x(7); % Global amplitude scale

[gwf, t]    = dime.convert.par2gwf(x, dur, tp);

% Apply global scale
gwf = gwf*gmax;

    function cost = this_cost(v)
        % unpack into temp parameters
        tmpA  = v(1);
        tmpB  = v(2);
        tmpRU = v(3);
        tmpRD = v(4);
        tmpRZ = v(5);
        tmpRZn= v(6);
        gGlo  = v(7);

        % recompute flat time
        fttt = dur - (2*(tmpRU+tmpRD) + (tmpRZ+tmpRZn));
        fttx = fttt * tmpB/2;
        fttz = fttt * (1 - tmpB);
        bx   = dime.convert.par2bval(tmpA, tmpRU, tmpRD, fttx,   0, 1);
        by   = bx;
        bz   = dime.convert.par2bval(   1, tmpRZ, tmpRZn, fttz, tp, 1);
        cost = -(bx + by + bz)*gGlo^2;
    end

    function [C, Ceq] = this_nlcon(v)
        a_tmp   = v(1);
        b_tmp   = v(2);
        ru_tmp  = v(3);
        rd_tmp  = v(4);
        rz_tmp  = v(5);
        rdz_tmp = v(6);
        % gGlo    = v(7);

        % recompute flat time
        fttt = dur - (2*(ru_tmp+rd_tmp) + (rz_tmp+rdz_tmp));
        fttx = fttt * b_tmp/2;
        fttz = fttt * (1 - b_tmp);

        % B-tensor parameters
        bx   = dime.convert.par2bval(a_tmp, ru_tmp, rd_tmp,  fttx,  0, 1);
        bz   = dime.convert.par2bval(    1, rz_tmp, rdz_tmp, fttz, tp, 1);
        B    = diag([bx bx bz]);
        bShp = dime.convert.tens2shape(B);

        % M-tensor parameters
        mShp = zeros(numel(opt.spectralOrder),1);

        for i = 1:numel(opt.spectralOrder)

            if opt.spectralOrder(i) == 2 % Analytic and fast
                mx   = dime.convert.par2mval(a_tmp, ru_tmp, rd_tmp,  fttx);
                mz   = dime.convert.par2mval(    1, rz_tmp, rdz_tmp, fttz);
                Mp   = diag([mx mx mz]);

            else % Numerical and slow(er)
                [gtmp1, ttmp1] = dime.convert.par2gwf(v, dur, tp);

                ut = unique(ttmp1);
                for cc = 1:3
                    [~, ix] = unique(ttmp1(:,cc));
                    gtmp2(:,cc) = interp1(ttmp1(ix,cc), gtmp1(ix,cc), ut);
                end

                Mp = now.calc.spectralMomentTensor(gtmp2, 1, ut(:,1)/1000, [], opt.spectralOrder(i), 1e4);
            end

            mShp(i) = dime.convert.tens2shape(Mp);
        end

        % Compile cost values
        C    = [bShp - opt.bAnisoTol;
                mShp - opt.mAnisoTol];

        Ceq  = [];


        if opt.stimMode % If nerve stimulation is to be accounted for

            [gwfTmp, tTmp]   = dime.convert.par2gwf(v, dur, tp);
            [gwfI, rfi, dti] = dime.convert.ana2num(gwfTmp, tTmp, 0.01);
            gwf_ste          = gwfI*gmax;

            c_pns = [];

            for i = 1:numel(hw)
                tmp = this_gwf2pnsCost(gwf_ste, rfi, dti, hw(i), opt.stimMode);
                c_pns = [c_pns tmp];
            end

            C = [C; (c_pns'- opt.stimTol)];
        end

    end
end


% ----- Support functions -----

function c_pns = this_gwf2pnsCost(gwf, rfi, dti, hw, mode)
% function c_pns = this_gwf2pnsCost(gwf, rfi, dti, hw, mode)

if mode
    pnsVals_ste = safe_gwf_to_pns(gwf, rfi, dti/1e3, hw, 0);
end

switch mode
    case 0
        c_pns = [];

    case 1 % One value per axis (1x3)
        c_pns = max(pnsVals_ste);

    case 2 % Global max value (1x1)
        c_pns = max(pnsVals_ste(:));

    case 3 % Global L2-norm (1x1)
        c_pns = max(vecnorm(pnsVals_ste,2,2));

    case 4 % One value per axis and the global L2-norm (1x4)
        c_pns = [max(pnsVals_ste) max(vecnorm(pnsVals_ste,2,2))];

    case 5 % LTE along y
        lte = dime.convert.ste2lte(gwf); lte = lte(:,1) * [0 1 0];
        pnsVals_lte = safe_gwf_to_pns(lte, rfi, dti/1e3, hw, 0);
        c_pns = max(pnsVals_lte(:,2));

    case 6 % per axis for STE and worst-case LTE
        lte = dime.convert.ste2lte(gwf); lte = lte(:,1) * [1 1 1];
        pnsVals_lte = safe_gwf_to_pns(lte, rfi, dti/1e3, hw, 0);
        c_pns = [max(pnsVals_ste(:)) max(pnsVals_lte(:))];

    case 7 % per axis for STE and worst-case LTE and L2-norm of STE
        lte = dime.convert.ste2lte(gwf);
        pnsVals_lte = safe_gwf_to_pns(lte, rfi, dti/1e3, hw, 0);
        c_pns = [max(pnsVals_ste(:)) max(pnsVals_lte(:)) max(vecnorm(pnsVals_ste,2,2))];

    otherwise
        error('Stimulation mode not recognized!')
end

end