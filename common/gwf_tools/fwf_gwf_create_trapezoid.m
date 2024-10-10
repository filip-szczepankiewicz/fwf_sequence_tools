function [gwf, n_ramp_use] = fwf_gwf_create_trapezoid(g, s, dt, n, do_rem_last)
% function [gwf, n_ramp_use] = fwf_gwf_create_trapezoid(g, s, dt, n, do_rem_last)
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% dt is the time step size in s
% n  is the total number of samples
% do_rem_last is a boolean. If true the final sample of the trapezoid is removed

if nargin < 1
    g = 80e-3;
    s = 100;
    dt = 1e-4;
    n = 100;
    do_rem_last = 1;

    [gwf, n_ramp_use] = fwf_gwf_create_trapezoid(g, s, dt, n, do_rem_last);

    clf
    plot((1:size(gwf,2))*dt, gwf)
end

if nargin < 5
    do_rem_last = 0;
end

if n > 3
    wf = ones(1,n)*nan;

    t_ramp = g / s;
    n_ramp = ceil(t_ramp / dt)+1;

    n_ramp_max = floor(n/2);

    wf_ramp = linspace(0,1,n_ramp);

    n_ramp_use = min([n_ramp_max n_ramp]);

    wf(1:n_ramp_use) = wf_ramp(1:n_ramp_use);

    wf = flip(wf);

    wf(1:n_ramp_use) = wf_ramp(1:n_ramp_use);

elseif n == 3
    wf = [0 dt*s/g 0];

else
    wf = zeros(1,n);
    
end

maxval = max(wf(~isnan(wf)));

wf(isnan(wf)) = maxval;

gwf = wf * g;

if do_rem_last
    gwf = gwf(1:(end-1));
end