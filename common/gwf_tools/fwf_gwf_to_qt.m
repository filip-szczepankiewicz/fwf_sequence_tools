function qt = fwf_gwf_to_qt(gwf, rf, dt, gamma)
% function qt = fwf_gwf_to_qt(gwf, rf, dt, gamma)

if nargin < 4
    gamma = fwf_gamma_from_nuc();
end

qt = gamma * cumsum(gwf.*rf, 1) * dt;