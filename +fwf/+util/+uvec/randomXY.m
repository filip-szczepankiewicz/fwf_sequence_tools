function u = randomXY(n)
% function u = fwf.util.uvec.randomXY(n)

u = randn(n,2);
u = u ./ sqrt(sum(u.^2, 2));
u = [u zeros(n,1)];