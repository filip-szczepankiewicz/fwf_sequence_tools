function gwf = ramp_constrained(g, s, dt, nmax)
% function gwf = fwf.gwf.create.ramp_constrained(g, s, dt, nmax)
%
% This function will create a ramp that is at most nmax elements and goes
% to the highest possible gradient amplitude in the allotted number of
% samples. If nmax is not large enough to achieve g, under the constraint
% of s, then the gradient waveform will stop at the highest possible g.
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% nmax is the maximal number of points along the ramp
% dt is the time step size in s

if nargin < 1
    g = 80e-3;
    s = 100;
    dt= 0.1e-3;
    nmax = 5;

    gwf = fwf.gwf.create.ramp_constrained(g, s, dt, nmax);

    clf
    plot(((1:size(gwf,2))-1)*dt, gwf)
    return
end

ntot = ceil(g/s/dt)+1;

gwf = linspace(0, g, ntot);

if numel(gwf) > nmax
    gwf = gwf(1:nmax);
end

