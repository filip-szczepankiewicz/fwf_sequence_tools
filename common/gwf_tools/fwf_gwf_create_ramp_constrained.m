function gwf = fwf_gwf_create_ramp_constrained(g, s, dt, nmax)
% function gwf = fwf_gwf_create_ramp_constrained(g, s, dt, nmax)

ntot = ceil(g/s/dt)+1;

gwf = linspace(0, g, ntot);

if numel(gwf) > nmax
    gwf = gwf(1:nmax);
end

