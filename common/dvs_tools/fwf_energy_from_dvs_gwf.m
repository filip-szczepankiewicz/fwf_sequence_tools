function [eps, b] = fwf_energy_from_dvs_gwf(dvs, gwfc, rfc, dtc)
% function [eps, b] = fwf_energy_from_dvs_gwf(dvs, gwfc, rfc, dtc)

for i = 1:numel(gwfc)
    tmp = abs(gwfc{i} * norm(dvs(i,1:3)));
    eps(i) = sum(tmp(:)) * dtc{i};
    b(i) = trace(fwf_gwf_to_btens(gwfc{i} * norm(dvs(i,1:3)), rfc{i}, dtc{i}));
end