function qt = fwf_gwf_to_qt(gwf, rf, dt, gamma)
% function qt = fwf_gwf_to_qt(gwf, rf, dt, gamma)
%
% Dephasing q-vecotr in units of rad/m

if nargin < 4
    gamma = fwf_gamma_from_nuc();
end

qt = gamma * cumsum(gwf.*rf, 1) * dt;