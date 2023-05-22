function qt = fwf_gwf_to_qt(gwf, rf, dt, nuc)
% function qt = fwf_gwf_to_qt(gwf, rf, dt, nuc)

if nargin < 4
    nuc = [];
end

qt = fwf_gamma_from_nuc(nuc) * cumsum(gwf.*rf, 1) * dt;