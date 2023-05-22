function [gwf, rf, dt] = fwf_gwf_create_sorland99(g, s, d, dp, dt, u)
% function [gwf, rf, dt] = fwf_gwf_create_sorland99(g, s, d, dp, dt, u)
%
% g is gradient amplitude
% s is slewrate
% d, dp are the durations of pulses and the pause.
% u is the directions of the pulse.

if nargin < 1
    [gwf, rf, dt] = fwf_gwf_create_sorland99(.08, 100, 11.6e-3, 8e-3, 1e-5, [1 0 0]);
    
    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end

n = round(d/dt);

wf  = fwf_gwf_create_trapezoid(g, s, dt, n);
wfz = zeros(1, round(dp/dt));

gwf = [
    wf'*u;
    wfz'*[1 1 1];
    wf'*u/2;
    -wf'*u/2;
    wfz'*[1 1 1];
    -wf'*u ];

rf = [ones(size(wf,2), 1); wfz'; -ones(2*size(wf,2), 1); wfz'; ones(size(wf,2), 1)];



