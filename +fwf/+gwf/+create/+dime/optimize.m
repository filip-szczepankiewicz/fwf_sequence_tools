function [gwf, t, x] = optimize(dur, tp, gmax, smax, hw, opt)
% function [gwf, t, x] = fwf.gwf.create.dime.optimize(dur, tp, gmax, smax, hw, opt)
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
%          x(7) gampGlo    Global amplitude scale. Not optimized; it is
%                          computed in closed form from x(1:6) as
%                          min(opt.ub(7), opt.stimTol/max(PNS at scale 1)).
%
%   Constraints enforced
%   --------------------
%   - b-tensor and m-tensor anisotropy tolerances (opt.bAnisoTol, opt.mAnisoTol),
%     as nonlinear constraints on x(1:6).
%   - Optional stimulation limits: max(PNS) / L2-norm / LTE variants depending
%     on opt.stimMode, with limit opt.stimTol (via SAFE prediction). These are
%     enforced exactly through the closed-form amplitude scale x(7), not as
%     fmincon constraints.

import fwf.gwf.create.*

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


% Reduced problem: only the shape parameters x(1:6) are optimized. The
% amplitude scale x(7) = gGlo is not a free variable. For a fixed shape, b
% scales as gGlo^2 while the isotropy constraints are scale invariant and
% every stimulation metric scales linearly with gGlo (SAFE is linear in
% dG/dt up to abs(), and max/L2-norm are positively homogeneous). The best
% gGlo is therefore min(opt.ub(7), opt.stimTol / max(PNS at gGlo = 1)),
% which is computed in closed form by this_gGlo. The optimum of this
% 6-parameter problem is the optimum of the original 7-parameter problem,
% except that opt.lb(7) is no longer enforced (see the check below).
ind = 1:6;

problem = createOptimProblem('fmincon',...
    'objective', @this_cost,...
    'x0', opt.x0(ind),...
    'lb', opt.lb(ind),...
    'ub', opt.ub(ind),...
    'nonlcon', @this_nlcon,...
    'options', opt.fmc);


switch opt.optMode
    case 0 % Single solve, works in simple setups
        v = fmincon(problem);

    case 1 % Global solver
        v = run(GlobalSearch('NumTrialPoints', opt.numTrialPts, 'NumStageOnePoints', opt.numInitialPts), problem);

    case 2 % Multistart solver
        v = run(MultiStart('UseParallel', true), problem, opt.numStartPts);
end

% Append the closed-form amplitude scale so that x keeps its 7-element
% layout and remains compatible with dime.convert.par2gwf.
x = [v(:)' this_gGlo(v)];

% opt.lb(7) is no longer a bound. It is only checked here; a scale below it
% means the shape is so stimulation-limited that the waveform is weak.
if x(7) < opt.lb(7)
    warning('dime:lowAmplitude', ['Stimulation limits the amplitude scale to %.3f, ' ...
        'below opt.lb(7) = %.3f.'], x(7), opt.lb(7));
end

% alpha       = x(1); % Fractional amplitude of xy gradient compared to z
% beta        = x(2); % Fraction of flat top time dedicated to xy gradients
% rampUpXY    = x(3); % Ramp up time for xy-gradient
% rampDownXY  = x(4); % Ramp down time for xy-gradient
% rampUpZ     = x(5); % Ramp up time for z-gradient
% rampDownZ   = x(6); % Ramp down time for z-gradient
% gampGlo     = x(7); % Global amplitude scale (closed form, not optimized)

[gwf, t] = dime.convert.par2gwf(x, dur, tp);

% Apply global scale
gwf = gwf*gmax;

    function cost = this_cost(v)
        [bx, bz] = this_bvals(v);
        by       = bx;
        gGlo     = this_gGlo(v);
        cost     = -(bx + by + bz)*gGlo^2;
    end

    function gGlo = this_gGlo(v)
        % Largest amplitude scale permitted by the gradient amplitude
        % (opt.ub(7)) and by stimulation (opt.stimTol).
        gGlo = opt.ub(7);

        if opt.stimMode
            cmax = this_pnsMaxAtUnitScale(v);

            if cmax > 0
                gGlo = min(gGlo, opt.stimTol / cmax);
            end
        end
    end

    function cmax = this_pnsMaxAtUnitScale(v)
        % Largest stimulation metric over all hardware models, for the
        % shape v at amplitude scale 1.
        [gwfTmp, tTmp]   = dime.convert.par2gwf([v(:)' 1], dur, tp);
        [gwfI, rfi, dti] = dime.convert.ana2num(gwfTmp, tTmp, 0.01);
        gwf_ste          = gwfI*gmax;

        c_pns = [];
        for i = 1:numel(hw)
            c_pns = [c_pns this_gwf2pnsCost(gwf_ste, rfi, dti, hw(i), opt.stimMode)]; %#ok<AGROW>
        end

        cmax = max(c_pns);
    end

    function [bx, bz, fttx, fttz] = this_bvals(v)
        % recompute flat time
        fttt = dur - (2*(v(3)+v(4)) + (v(5)+v(6)));
        fttx = fttt * v(2)/2;
        fttz = fttt * (1 - v(2));
        bx   = dime.convert.par2bval(v(1), v(3), v(4), fttx,  0, 1);
        bz   = dime.convert.par2bval(   1, v(5), v(6), fttz, tp, 1);
    end

    function [C, Ceq] = this_nlcon(v)
        % Only the scale-invariant isotropy constraints remain. Stimulation
        % is handled by the closed-form amplitude scale in this_gGlo.
        [bx, bz, fttx, fttz] = this_bvals(v);

        % B-tensor parameters
        B    = diag([bx bx bz]);
        bShp = dime.convert.tens2shape(B);

        % M-tensor parameters
        mShp = zeros(numel(opt.spectralOrder),1);

        for i = 1:numel(opt.spectralOrder)

            if opt.spectralOrder(i) == 2 % Analytic and fast
                mx   = dime.convert.par2mval(v(1), v(3), v(4), fttx);
                mz   = dime.convert.par2mval(   1, v(5), v(6), fttz);
                Mp   = diag([mx mx mz]);

            else % Numerical and slow(er)
                [gtmp1, ttmp1] = dime.convert.par2gwf([v(:)' 1], dur, tp);

                ut    = unique(ttmp1);
                gtmp2 = zeros(numel(ut), 3);
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
    end
end


% ----- Support functions -----

function c_pns = this_gwf2pnsCost(gwf, rfi, dti, hw, mode)
% function c_pns = this_gwf2pnsCost(gwf, rfi, dti, hw, mode)

import fwf.gwf.create.*

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