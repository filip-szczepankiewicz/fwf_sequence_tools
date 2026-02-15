function kappa = toEfficiency(gwf, rf, dt, gmax)
% function kappa = fwf.gwf.toEfficiency(gwf, rf, dt, gmax)

if nargin < 4
    gmax = max(abs(gwf(:)));
end

b  = fwf.gwf.toBvalue(gwf, rf, dt);
tt = size(gwf, 1)*dt;
ga = fwf.util.gammaFromNuc();

kappa = 4*b/ga^2/gmax^2/tt^3;