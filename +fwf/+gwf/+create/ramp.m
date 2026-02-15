function gwf = ramp(g, s, dt, n)
% function gwf = fwf.gwf.create.ramp(g, s, dt, n)
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% n  is the number of points along the ramp
% dt is the time step size in s

if nargin < 1
    ttot = 1e-3; % This is the desired duration.

    g = 80e-3;
    s = 100;
    dt= 0.1e-3;
    n = ceil(ttot/dt)+1;

    gwf = fwf.gwf.create.ramp(g, s, dt, n);

    clf
    plot([0:(n-1)]*dt, gwf)
    return
end

ttot = g/s;

if nargin < 4
    n_ramp = ceil(ttot/dt)+1;
else
    n_ramp = n;
end

gwf = linspace(0,g,n_ramp);

