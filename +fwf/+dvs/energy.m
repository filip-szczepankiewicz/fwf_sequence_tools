function eps = energy(gwfc, rfc, dtc, ax_factor)
% function eps = energy(gwfc, rfc, dtc, ax_factor)

if nargin < 4
    ax_factor = [1 1 1];
end

for i = 1:numel(gwfc)
    eps(i) = sum(sum(gwfc{c}.^2,1) .* ax_factor) * dtc{i};
end