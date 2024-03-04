function u = fwf_uvec_random(n)

u = randn(n,3);
u = u ./ sqrt(sum(u.^2, 2));