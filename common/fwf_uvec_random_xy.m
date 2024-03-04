function u = fwf_uvec_random_xy(n)

u = randn(n,2);
u = u ./ sqrt(sum(u.^2, 2));
u = [u zeros(n,1)];