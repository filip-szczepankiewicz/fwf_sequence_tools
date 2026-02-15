function t = fwf_gwf_to_time(gwf, rf, dt, tstart)
% function t = fwf_gwf_to_time(gwf, rf, dt, tstart)

if nargin < 4
    tstart = 0;
end

n = size(gwf,1);

tmax = (n-1)*dt;

t = linspace(0, tmax, n)+tstart;