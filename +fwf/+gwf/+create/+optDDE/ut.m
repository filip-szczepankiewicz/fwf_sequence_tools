function ut(n)
% function optDDE.ut
% By Filip Szepankiewicz, Lund University
%
% Simple unit test for bip optimizer

import fwf.gwf.create.*

if nargin < 1
    n = [1 2];
end

dt   = 0.1e-3; % s

for i = 1:numel(n)

    clear hw

    switch n(i)
        case 1
            dur = 22; % ms
            tp  = 8;
            gmax = 0.08; % T/m
            smax = 200;  % T/m/s

            hw = safe_hw_prisma_xr_sh05;

        case 2
            dur = 15.5; % ms
            tp  = 4;
            gmax = 0.2; % T/m
            smax = 200;  % T/m/s

            hw(1) = safe_hw_cimaX_cardiac;
            hw(2) = safe_hw_cimaX_peripheral;

    end

    opt           = optDDE.options(gmax, smax, dur);

    [gwf, t]      = optDDE.optimize(dur, tp, gmax, smax, hw, opt);
    [gwf, rf, dt] = optDDE.convert.ana2num(gwf, t/1000, dt);

    if 1
        figure(i)
        clf
        optDDE.plot.gwfSetAndStim(gwf, rf, dt, hw)
    end

end
