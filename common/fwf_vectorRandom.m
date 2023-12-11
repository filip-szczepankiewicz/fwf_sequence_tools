function u = fwf_vectorRandom(n)
% function u = fwf_vectorRandom(n)

u = randn(n,3);
u = u./sqrt(sum(u.^2, 2));