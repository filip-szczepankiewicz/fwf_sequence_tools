function [gwf, n_ramp_use] = fwf_gwf_create_trapezoid(gamp, slew, dt, n_samp, do_rem_last)
% function [gwf, n_ramp_use] = fwf_gwf_create_trapezoid(gamp, slew, dt, n_samp, do_rem_last)

if nargin < 5
    do_rem_last = 0;
end

if n_samp > 3
    wf = ones(1,n_samp)*nan;

    t_ramp = gamp / slew;
    n_ramp = ceil(t_ramp / dt)+1;

    n_ramp_max = floor(n_samp/2);

    wf_ramp = linspace(0,1,n_ramp);

    n_ramp_use = min([n_ramp_max n_ramp]);

    wf(1:n_ramp_use) = wf_ramp(1:n_ramp_use);

    wf = flip(wf);

    wf(1:n_ramp_use) = wf_ramp(1:n_ramp_use);

elseif n_samp == 3
    wf = [0 dt*slew/gamp 0];

else
    wf = zeros(1,n_samp);
    
end

maxval = max(wf(~isnan(wf)));

wf(isnan(wf)) = maxval;

gwf = wf * gamp;

if do_rem_last
    gwf = gwf(1:(end-1));
end