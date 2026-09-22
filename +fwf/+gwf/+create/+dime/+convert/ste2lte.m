function lte = ste2lte(gwf)
% function lte = dime.convert.ste2lte(gwf)

lte = sum(gwf .* [-1 1 1], 2) * [1 0 0];