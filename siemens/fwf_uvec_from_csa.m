function [u, n] = fwf_uvec_from_csa(csa)
% function u = fwf_uvec_from_csa(csa)
% These are most likely in patient coord system.

str_fnd = 'sDiffusion.sFreeDiffusionData.asDiffDirVector[';

ind = strfind(csa, str_fnd);
ind2 = ind+length(str_fnd)+12;

for j = 1:numel(ind)
    u(j) = sscanf(csa(ind2(j):(ind2(j)+20)), '%g', 1);
end

u = reshape(u, 3, length(u)/3)';

n = sqrt(sum(u.^2, 2));