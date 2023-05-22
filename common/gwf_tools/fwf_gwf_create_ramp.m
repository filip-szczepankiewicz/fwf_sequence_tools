function gwf = fwf_gwf_create_ramp(gamp, slew, dt, n)
% function gwf = fwf_gwf_create_ramp(gamp, slew, dt, n)

if nargin < 1
    ttot = 2e-3;
    gamp = 80e-3;
    slew = 100;
    dt   = 0.1e-3;
    n    = ceil(ttot/dt)+1;
end

ttot = gamp/slew;

if nargin < 4
    n_ramp = ceil(ttot/dt)+1;
else
    n_ramp = n;
end

gwf = linspace(0,gamp,n_ramp);

