function u = random(n)
% function u = fwf.util.uvec.random(n)

u = randn(n,3);
u = u ./ sqrt(sum(u.^2, 2));