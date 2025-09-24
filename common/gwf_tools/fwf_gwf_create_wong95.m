function [gwf, rf, dt] = fwf_gwf_create_wong95(g, s, d, dp, dt)
% function [gwf, rf, dt] = fwf_gwf_create_wong95(gamp, slew, d, dp, dt)
%
% Wong et al 1995, MRM, Figure 1b
% It is supposed to be self-balanced, but timing likely depends on ramp
% time since one zero crossing is "missing" on the x-axis at t = 0.500.
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d  is the duration of each single trapezoid pulse in s
% dp is the duration of the pause in s
% dt is the time step size in s
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 36e-3;
    dp = 8e-3;
    dt = 0.01e-3;

    [gwf, rf, dt] = fwf_gwf_create_wong95(g, s, d, dp, dt);

    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt)
    return
end

z = {
    [0 .256      .744 1]
    [0 .124 .500 .876 1]
    [0 .231 .500 .769 1]};

signs = {[1 -1 1], [1 -1 1 -1], [1 -1 1 -1]};

wf{1} = [];
wf{2} = [];
wf{3} = [];

for i = 1:3
    zp = z{i};
    zs = signs{i};
    
    for j = 2:numel(zp)
        tenc = (zp(j)-zp(j-1))*d;
        trap_wf = fwf_gwf_create_trapezoid(g, s, dt, floor(tenc/dt));
        wf{i} = [wf{i} trap_wf * zs(j-1)];
        
    end
end

for i = 1:3
    l(i) = numel(wf{i});
end

ml = max(l);

for i = 1:3
    tmp = wf{i};
    tmp(end:ml) = 0;
    wf{i} = tmp;
end

gpart = [wf{1}; wf{2}; wf{3}];

z = zeros(3, round(dp/dt));

gwf = [gpart'; z'; gpart'];

rf  = [ones(length(gpart),1); zeros(round(dp/dt),1); -ones(length(gpart),1)];

B = fwf_gwf_to_btens(gwf, rf, dt);

for i = 1:3
    gpart(i,:) = gpart(i,:) * sqrt((min(diag(B)) / B(i,i)));
end


