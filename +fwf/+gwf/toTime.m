function t = toTime(gwf, rf, dt, tstart)
% function t = fwf.gwf.toTime(gwf, rf, dt, tstart)

if nargin < 4
    tstart = 0;
end

n = size(gwf,1);

tmax = (n-1)*dt;

t = linspace(0, tmax, n)+tstart;