function [gwf, rf, dt] = fwf_gwf_create_mori95_pattern1(g, s, d, dp, dt)
% function [gwf, rf, dt] = fwf_gwf_create_mori95_pattern1(g, s, d, dp, dt)
%
% Pattern I (TDE) in Mori and van Zijl MRM (1995), see figure 2.
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
    d = 10.8e-3;
    dp = 8e-3;
    dt = 0.05e-3;
    
    [gwf, rf, dt] = fwf_gwf_create_mori95_pattern1(g, s, d, dp, dt);
    
    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end

u1 = [1 0 0];
u2 = [0 1 0];
u3 = [0 0 1];

n = round(d/dt);

trp = fwf_gwf_create_trapezoid(g, s, dt, n);
bip = [trp -trp];

wfz = zeros(1, round(dp/dt));

gwf = [
    bip'*u1;
    bip'*u2;
    bip'*u3;
    wfz'*[1 1 1];
    bip'*u1;
    bip'*u2;
    bip'*u3; ];

rf = ones(size(gwf,1),1);
mind = round(size(gwf,1)/2);
rf(mind:end) = -1;

