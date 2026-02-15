function qt = toQt(gwf, rf, dt, gamma)
% function qt = fwf.gwf.toQt(gwf, rf, dt, gamma)
%
% Dephasing q-vecotr in units of rad/m

if nargin < 4
    gamma = fwf.util.gammaFromNuc();
end

qt = gamma * cumsum(gwf.*rf, 1) * dt;