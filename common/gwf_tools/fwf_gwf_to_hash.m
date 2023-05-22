function hash = gwf_to_hash(gwf)
% function hash = gwf_to_hash(gwf)
% By FSz
%
% Function is a very improvised hash function for gwfs. Hopefully the
% result is unlikely to be the same for different gwfs, but I am not sure.

warning('shitty test function')

siz = size(gwf(:));

hash = 0;

for i = 1:siz
    x = bitshift(typecast(gwf(i), 'uint64'), -16)+i;
    hash = hash + double(x);
end

hash = dec2bin(typecast(hash, 'uint64'), 64);