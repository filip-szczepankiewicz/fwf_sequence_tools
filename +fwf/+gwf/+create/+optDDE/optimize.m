function [gwf, t, x] = optimize(dur, tp, gmax, smax, hw, opt)
% function [gwf, t, x] = optDDE.optimize(dur, tp, gmax, smax, hw, opt)
% By Filip Szczepankiewicz, Lund University
%
%   Designs a bipolar LTE diffusion-encoding gradient waveform (GWF) that maximizes
%   diffusion weighting (b-value) for a fixed timing budget, while enforcing
%   gradient hardware limits, and (optionally) nerve stimulation (PNS and CSN)
%   limits using SAFE PNS prediction.
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
%          0 disables PNS constraints; 1+ enable different PNS metrics
%          (see gwf2pnsCost for definitions).
%   hw   - SAFE hardware model struct array used for PNS and CNS prediction
%          (see safe_* functions; e.g. safe_example_hw_peripheral).
%          Requires https://github.com/filip-szczepankiewicz/safe_pns_prediction
%   opt  - Options struct for the optimizer and constraint tolerances.
%          Default is created by optDDE.options(gmax, smax, dur).
%          opt.optMode = 0, 1, or 2 allows selection between:
%          0: Single optimization with fmincon
%          1: GlobalSearch with fmincon
%          2: MultiStart with fmincon (default)
%
%   Outputs
%   -------
%   gwf  - Optimized gradient waveform [T/m], size [n x 1]. Note that this
%          waveform only includes the analytical representations. To get a
%          useful waveforms please call optDDE.convert.ana2num(gwf, t, dt)
%   t    - Time points for gwf [ms]. These are unique per axis!
%   x    - Optimized parameter vector:
%          x(1) alpha      Fractional amplitude of x/y vs z
%          x(2) beta       Fraction of encoding time dedicated to x/y
%          x(3) rampUpXY   Ramp-up time for x/y gradients
%
%   Constraints enforced
%   --------------------
%   - Gradient amplitude and Slew rate
%   - Optional stimulation constraints

import fwf.gwf.create.*

if nargin < 1
    dur  = 10.5; % ms
    tp   = 10;  % ms
    gmax = 0.08; % T/m
    smax = 200;  % T/m/s

    opt = optDDE.options(gmax, smax, dur);
    hw  = safe_example_hw_peripheral;

    [gwf, t] = optDDE.optimize(dur, tp, gmax, smax, hw, opt);

    dt = 0.1e-3; % Raster time of interpolated waveform
    [gwf, rf, dt] = optDDE.convert.ana2num(gwf, t/1000, dt);

    clf
    optDDE.plot.gwfSetAndStim(gwf, rf, dt, hw);
end

if nargin < 6
    opt = optDDE.options(gmax, smax, dur);
end

% Check that problem is reasonable
assert(sum(opt.lb([1 2]))<dur, 'Shortest ramps do not fit in duration! Dur must be longer!')
assert(sum(opt.ub([1 2]))<dur, 'Longest ramps do not fit in duration! Consider extending dur or shortening the max ramp times.')


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

[gwf, t]  = optDDE.convert.par2gwf(x, dur, tp);

% Apply global scale
gwf = gwf*gmax;

    function cost = this_cost(v)
        % unpack into temp parameters
        tmpA  = v(1);
        tmpB  = v(2);
        gGlo  = v(3);

        % recompute flat time
        ftt  = dur/2 - (tmpA + tmpB);
        b    = optDDE.convert.par2bval(tmpA, tmpB, ftt, tp, gGlo);
        cost = -b;
    end

    function [C, Ceq] = this_nlcon(v)
        % Const funciton based on B and M tensor shapes
        C    = [];
        Ceq  = [];

        if opt.stimMode % If nerve stimulation is to be accounted for

            [gwfTmp, tTmp]   = optDDE.convert.par2gwf(v, dur, tp);
            [gwfI, rfi, dti] = optDDE.convert.ana2num(gwfTmp, tTmp, 0.01);
            gwf_tmp          = gwfI*gmax;

            c_pns = [];

            for i = 1:numel(hw)
                tmp = this_gwf2pnsCost(gwf_tmp, rfi, dti, hw(i), opt.stimMode);
                c_pns = [c_pns tmp];
            end

            C = [C; (c_pns'- opt.stimTol)];
            1;
        end

    end
end


% ----- Support functions -----

function c_pns = this_gwf2pnsCost(gwf, rfi, dti, hw, mode)
% function c_pns = this_gwf2pnsCost(gwf, rfi, dti, hw, mode)

if mode
    gwf = gwf * [1 1 1];
    pnsVals_ste = safe_gwf_to_pns(gwf, rfi, dti/1e3, hw, 0);
end

switch mode
    case 0
        c_pns = [];

    case 1 % One value per axis (1x3)
        c_pns = max(pnsVals_ste(:));

    otherwise
        error('Stimulation mode not recognized!')
end

end