function [gwf, rf, dt] = fwf_gwf_create_wong95(gamp, slew, d1, dp, dt)
% function [gwf, rf, dt] = fwf_gwf_create_wong95(gamp, slew, d1, dp, dt)
%
% Wong et al 1995, MRM
% Figure 1b

if nargin < 1
    gamp = 80e-3;
    slew = 100;
    d1 = 30e-3;
    dp = 8e-3;
    dt = 0.01e-3;

    [gwf, rf, dt] = fwf_gwf_create_wong95(gamp, slew, d1, dp, dt);

    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt)
    return
end


z = {
    [0 .256      .744 1]
    [0 .124 .500 .876 1]
    [0 .231 .500 .769 1]};

s = {[1 -1 1], [1 -1 1 -1], [1 -1 1 -1]};

wf{1} = [];
wf{2} = [];
wf{3} = [];

for i = 1:3
    
    zp = z{i};
    zs = s{i};
    
    for j = 2:numel(zp)
        
        tenc = (zp(j)-zp(j-1))*d1;
        
        trap_wf = fwf_gwf_create_trapezoid(gamp, slew, dt, floor(tenc/dt));
        
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

g = [wf{1}; wf{2}; wf{3}];

z = zeros(3, round(dp/dt));

gwf = [g'; z'; g'];

rf  = [ones(length(g),1); zeros(round(dp/dt),1); -ones(length(g),1)];

B = fwf_gwf_to_btens(gwf, rf, dt);

for i = 1:3
   
    g(i,:) = g(i,:) * sqrt((min(diag(B)) / B(i,i)));
    
end


% It is supposed to be self-balanced, but timing likely depends on ramp
% time since ont zero crossing is "missing" on the x-axis at t = 0.500.
% if sum(abs(sum(g'))) > 0.0001
%     error('not balanced')
% end