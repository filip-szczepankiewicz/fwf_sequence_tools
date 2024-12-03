function kappa = fwf_gwf_to_efficiency(gwf, rf, dt, gmax)
% function kappa = fwf_gwf_to_efficiency(gwf, rf, dt, gmax)

if nargin < 4
    gmax = max(abs(gwf(:)));
end

b  = fwf_gwf_to_bval(gwf, rf, dt);
tt = size(gwf, 1)*dt;
ga = fwf_gamma_from_nuc();

kappa = 4*b/ga^2/gmax^2/tt^3;


