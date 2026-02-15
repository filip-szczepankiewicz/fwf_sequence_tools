function [gwf, rf, dt] = sorland99(g, s, d, dp, dt, u)
% function [gwf, rf, dt] = fwf.gwf.create.sorland99(g, s, d, dp, dt, u)
%
% g is gradient amplitude in T/m
% s is slewrate in T/m/s
% d, dp are the durations of pulses and the pause in s.
% u is the directions of the pulse.

if nargin < 1
    g  = .08;
    s  = 100;
    d  = 11.6e-3;
    dp = 8e-3;
    dt = 1e-5;
    u  = [1 0 0];

    [gwf, rf, dt] = fwf.gwf.create.sorland99(g, s, d, dp, dt, u);
    
    clf
    fwf.plot.wf2d(gwf, rf, dt);
    return
end

n = round(d/dt);

wf  = fwf.gwf.create.trapezoid(g, s, dt, n);
wfz = zeros(1, round(dp/dt));

gwf = [
    wf'*u;
    wfz'*[1 1 1];
    wf'*u/2;
    -wf'*u/2;
    wfz'*[1 1 1];
    -wf'*u ];

rf = [ones(size(wf,2), 1); wfz'; -ones(2*size(wf,2), 1); wfz'; ones(size(wf,2), 1)];



