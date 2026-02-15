function gmin = fwf_gwf_to_minimal_projection(gwf, u)
% function gmin = fwf_gwf_to_minimal_projection(gwf, u)

if nargin < 2
    u = randn(1000,3);
    zi = all(gwf==0, 1);
    u(:,zi) = 0;
    u = u./sqrt(sum(u.^2,2));
end

for i = 1:size(u,1)
    
    g(i) = max(abs(gwf * u(i,:)'));
    
end

[~, mi] = min(g);

gmin = gwf*u(mi,:)';