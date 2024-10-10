function [gwf, rf, dt] = fwf_gwf_create_dsedde(g, s, d1, d2, dmix, dt, u1, u2, dp)
% function [gwf, rf, dt] = fwf_gwf_create_dsedde(g, s, d1, d2, dmix, dt, u1, u2, dp)
%
% This function creates double diffusion encoding in a double spin echo
% (two refocusing pulses).
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d1 is the duration of the first pulse pair s
% d2 is the duration of the second pulse pair in s 
% dmix is the mixing time in s
% dp is the duration of the pause in s
% dt is the time step size in s
% uX is the direction of pulse pairs, 1x3 unit vectors
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g = 0.08;
    s = 100;
    d1 = 24.7e-3;
    d2 = d1;
    dmix = 10e-3;
    dt = 1e-5;
    u1 = [1 0 0];
    u2 = [0 1 0];
    dp = 8e-3;
    [gwf, rf, dt] = fwf_gwf_create_dsedde(g, s, d1, d2, dmix, dt, u1, u2, dp);

    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end


n1 = round(d1/dt/2);
n2 = round(d2/dt/2);

np = round(dp/dt);
zn = zeros(1, np);

nz1 = round(np/2);
nz2 = np-nz1;

wf1 = [fwf_gwf_create_trapezoid(g, s, dt, n1) zn fwf_gwf_create_trapezoid(g, s, dt, n1) 0]';
wf2 = [fwf_gwf_create_trapezoid(g, s, dt, n2) zn fwf_gwf_create_trapezoid(g, s, dt, n2) 0]';

nm  = round(dmix/dt);
wfz = zeros(1, nm)';

gwf = [
    wf1*u1;
    wfz*[1 1 1];
    wf2*u2 ];

rf = [ones(n1+nz1,1); -ones(nz2+n1+nm+n2+nz1+2, 1); ones(n2+nz2,1)];



