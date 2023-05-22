function [gwf, rf, dt] = fwf_gwf_create_sedde(g, s, d1, d2, dp, dt, u1, u2, dp2)
% function [gwf, rf, dt] = fwf_gwf_create_sedde(g, s, d1, d2, dp, dt, u1, u2, dp2)
%
% g is gradient amplitude
% s is slewrate
% d1, d2, dp are the durations of first and second bipoles, and the pause
% time.
% u1 and u2 are the directions of the first and second bipoles.

if nargin < 1
    [gwf, rf, dt] = fwf_gwf_create_sedde(.08, 100, 31e-3, 31e-3, 8e-3, 1e-5, [1 0 0], [0 0 1]);
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

wf1 = [fwf_gwf_create_trapezoid(g, s, dt, n1) zn -fwf_gwf_create_trapezoid(g, s, dt, n1) 0]';
wf2 = [fwf_gwf_create_trapezoid(g, s, dt, n2) zn -fwf_gwf_create_trapezoid(g, s, dt, n2) 0]';
wfz = zeros(1, round(dp/dt))';

gwf = [
    wf1*u1;
    wfz*[1 1 1];
    wf2*u2 ];

rf = ones(size(gwf,1),1);
mind = size(wf1,1) + round(size(wfz,1)/2);
rf(mind:end) = -1;



