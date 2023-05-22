function [gwf, rf, dt] = fwf_gwf_create_dsedde(g, s, d1, d2, dmix, dt, u1, u2, dp)
% function [gwf, rf, dt] = fwf_gwf_create_dsedde(g, s, d1, d2, dmix, dt, u1, u2, dp)

if nargin < 1
    [gwf, rf, dt] = fwf_gwf_create_dsedde(.08, 100, 24.7e-3, 24.7e-3, 1e-3, 1e-5, [1 0 0], [0 0 1], 8e-3);

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



