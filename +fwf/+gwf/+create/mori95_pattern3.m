function [gwf, rf, dt, ind] = mori95_pattern3(g, s, d, dp, dt)
% function [gwf, rf, dt, ind] = fwf.gwf.create.mori95_pattern3(g, s, d, dp, dt)
%
% Pattern III in Mori and van Zijl MRM (1995).
% https://onlinelibrary.wiley.com/doi/abs/10.1002/mrm.1910330107
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d  is the duration of each encoding period
% dp is the duration of the pause in s
% dt is the time step size in s
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 8.65e-3;
    dp = 8e-3;
    dt = 0.05e-3;

    [gwf, rf, dt] = fwf.gwf.create.mori95_pattern3(g, s, d, dp, dt);

    clf
    fwf.plot.wf2d(gwf, rf, dt);
    return
end

u1 = [ 1  1  1];
u2 = [-1  1  1];
u3 = [ 1 -1  1];
u4 = [ 1  1 -1];

n = round(d/dt);

trp = fwf.gwf.create.trapezoid(g, s, dt, n);
trp = trp(1:(end-1));
bip = [trp -trp];

wfz = zeros(1, ceil(dp/dt));

gwf = [
    bip'*u1;
    bip'*u2;
    [0 0 0];
    wfz'*[1 1 1];
    bip'*u3;
    bip'*u4;
    [0 0 0];
    ];

rf = ones(size(gwf,1),1);
mind = round(size(gwf,1)/2);
rf(mind:end) = -1;

ind = zeros(length(gwf),1);
ind(1:length([bip bip 0])) = 1;
ind(length([bip bip wfz 0 0]):end) = 2;

