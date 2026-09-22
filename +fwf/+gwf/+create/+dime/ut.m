function ut(n)
% function dime.ut
% By Filip Szepankiewicz, Lund University
%
% Simple unit test for dime optimizer. NOTE that this is not supposed to
% run for the general user as it uses confidential code for the SAFE
% simulation.

import fwf.gwf.create.*

if nargin < 1
    n = [0 1 2 3];
end

dt   = 0.1e-3; % s

c = 1;
for i = 1:numel(n)

    clear hw

    switch n(i)
        case 0 % Stim control off
            dur = 40; % ms
            tp  = 8; % ms
            gmax = 0.08; % T/m
            smax = 200;  % T/m/s

            hw  = safe_hw_prisma_xr_sh05;
            opt = dime.options(gmax, smax, dur);
            opt.stimMode = 0;

        case 1 % Prisma
            dur = 40; % ms
            tp  = 8; % ms
            gmax = 0.08; % T/m
            smax = 200;  % T/m/s

            hw  = safe_hw_prisma_xr_sh05;
            opt = dime.options(gmax, smax, dur);

        case 2 % Cima.X
            dur = 28; % ms
            tp  = 4; % ms
            gmax = 0.2; % T/m
            smax = 200;  % T/m/s

            hw(1) = safe_hw_cimaX_cardiac;
            hw(2) = safe_hw_cimaX_peripheral;
            opt   = dime.options(gmax, smax, dur);

        case 3 % Cima without demand on M-isotropy
            dur = 28; % ms
            tp  = 4; % ms
            gmax = 0.2; % T/m
            smax = 200;  % T/m/s

            hw(1) = safe_hw_cimaX_cardiac;
            hw(2) = safe_hw_cimaX_peripheral;
            opt   = dime.options(gmax, smax, dur);
            opt.mAnisoTol = 1;

    end

    [gwf, t]      = dime.optimize(dur, tp, gmax, smax, hw, opt);
    [gwf, rf, dt] = dime.convert.ana2num(gwf, t/1000, dt);

    if 1
        figure(c); c = c+1;
        clf
        dime.plot.gwfSetAndStim(gwf, rf, dt, hw)
    end

end
