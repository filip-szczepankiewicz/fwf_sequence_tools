function [gwf, rf, dt] = fwf_gwf_create_magdoom22(g, s, d, dp, dt, u1, u2)
% function [gwf, rf, dt] = fwf_gwf_create_magdoom22(g, s, d, dp, dt, u1, u2)
% g is gradient amplitude
% s is slewrate
% d1, d2, dp are the durations of first and second bipoles, and the pause
% time.
% u1 and u2 are the directions of the first and second bipoles.

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 24.1e-3;
    dp = (8+6)*1e-3;
    dt = 0.1e-3;
    u1 = [1 0 0];
    u2 = [0 1 0];
    [gwf, rf, dt] = fwf_gwf_create_magdoom22(g, s, d, dp, dt, u1, u2);
    
    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end

n  = round(d/dt);
n1 = round(d/dt/2);
n2 = n-n1;

np = round(dp/dt);

wf1 = fwf_gwf_create_trapezoid(g, s, dt, n1);
wf2 = fwf_gwf_create_trapezoid(g, s, dt, n2);
wfz = zeros(np,3);
    

gwf = [
    wf1'*u1;
    wf2'*u2;
    wfz;
    wf1'*u1;
    wf2'*u2 ];

rf = ones(size(gwf,1),1);
mid = round(size(gwf,1)/2);
rf(mid:end) = -1;

