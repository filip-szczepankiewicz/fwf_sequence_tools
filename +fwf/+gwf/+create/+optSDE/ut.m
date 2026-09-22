function ut(n)
% function optSDE.ut
% By Filip Szepankiewicz, Lund University
%
% Simple unit test for mono optimizer

import fwf.gwf.create.*

if nargin < 1
    n = [1 2];
end

mode = 1;
dt   = 0.1e-3; % s

for i = 1:numel(n)

    clear hw

    switch n(i)
        case 1
            dur = 10.5; % ms
            tp  = 8;
            gmax = 0.08; % T/m
            smax = 200;  % T/m/s

            hw = safe_hw_prisma_xr_sh05;

        case 2
            dur = 7.5; % ms
            tp  = 4;
            gmax = 0.2; % T/m
            smax = 200;  % T/m/s

            hw(1) = safe_hw_cimaX_cardiac;
            hw(2) = safe_hw_cimaX_peripheral;

    end

    opt           = optSDE.options(gmax, smax, dur);

    [gwf, t]      = optSDE.optimize(dur, tp, gmax, smax, hw, opt);
    [gwf, rf, dt] = optSDE.convert.ana2num(gwf, t/1000, dt);

    if 1
        figure(i)
        clf
        optSDE.plot.gwfSetAndStim(gwf, rf, dt, hw)
    end

end
