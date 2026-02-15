function [gwf, rf, dt] = ahn87(g, s, d1, d2, dp, dt, u, dp2)
% function [gwf, rf, dt] = fwf_gwf_create_ahn87(g, s, d1, d2, dp, dt, u, dp2)
% 
% See reference
% Ahn et al. Med. Phys. 1987

% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d1 is the duration of the first pulse pair s
% d2 is the duration of the second pulse pair in s 
% dp is the duration of the pause in s
% dt is the time step size in s
% u  is the direction of both pulse pairs, 1x3 unit vector
% dp2 is the pause between pulses in each pair in s
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g = 0.08;
    s = 100;
    d1 = 30e-3;
    d2 = 30e-3;
    dt = 4e-5;
    u = [1 0 0];
    dp = 8e-3;
    dp2 = 1e-3;

    [gwf, rf, dt] = fwf.gwf.create.ahn87(g, s, d1, d2, dp, dt, u, dp2);

    clf
    fwf.plot.wf2d(gwf, rf, dt);
    return
end

[gwf, rf, dt] = fwf.gwf.create.dde_se(g, s, d1, d2, dp, dt, u, u, dp2);