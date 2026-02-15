function [gwf, rf, dt] = dde_se(g, s, d1, d2, dp, dt, u1, u2, dp2)
% function [gwf, rf, dt] = fwf_gwf_create_sedde(g, s, d1, d2, dp, dt, u1, u2, dp2)
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d1 is the duration of the first pulse pair s
% d2 is the duration of the second pulse pair in s 
% dp is the duration of the pause in s
% dt is the time step size in s
% uX is the direction of pulse pairs, 1x3 unit vectors
% dp2 is the pause between pulses in each pair in s
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g = 0.08;
    s = 100;
    d1 = 30e-3;
    d2 = 30e-3;
    dt = 1e-5;
    u1 = [1 0 0];
    u2 = [0 0 1];
    dp = 8e-3;
    dp2 = 1e-3;

    [gwf, rf, dt] = fwf.gwf.create.dde_se(g, s, d1, d2, dp, dt, u1, u2, dp2);

    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end

if nargin < 9
    dp2 = 0;
end

n1 = round(d1/dt/2);
n2 = round(d2/dt/2);

np = round(dp2/dt);
zn = zeros(1, np);

wf1 = [fwf.gwf.create.trapezoid(g, s, dt, n1) zn -fwf.gwf.create.trapezoid(g, s, dt, n1) 0]';
wf2 = [fwf.gwf.create.trapezoid(g, s, dt, n2) zn -fwf.gwf.create.trapezoid(g, s, dt, n2) 0]';
wfz = zeros(1, round(dp/dt))';

gwf = [
    wf1*u1;
    wfz*[1 1 1];
    wf2*u2 ];

rf = ones(size(gwf,1),1);
mind = size(wf1,1) + round(size(wfz,1)/2);
rf(mind:end) = -1;



