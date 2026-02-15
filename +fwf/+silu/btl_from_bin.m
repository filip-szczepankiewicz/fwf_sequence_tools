function [bt, ver, sha] = btl_from_bin(bin_fn, gamp, t_pause, dt, gamma)
% function [bt, ver, sha] = fwf.silu.btl_from_bin(bin_fn, gamp, t_pause, dt, gamma)
% NOTE: This function does not include the effect of averages and multiple
% b-values, so it only coarsly depicts what is acquired by the scanner.

if nargin < 5
    gamma = fwf.util.gammaFromNuc('1H');
end

[GWF, ver, sha] = fwf.silu.bin_read(bin_fn);

n  = size(GWF,2);

na = size(GWF{1,1},1);
nb = size(GWF{2,1},1);

nz  = round(t_pause/dt);
nz1 = round(nz/2);
nz2 = nz-nz1;

rf = [ones(na+nz1,1); -ones(nb+nz2,1)];

bt = zeros(n,6);

for i = 1:size(GWF,2)
    gwf  = [GWF{1,i}; zeros(nz,3); GWF{2,i}] * gamp;
    B    = fwf.gwf.toBtensor(gwf, rf, dt, gamma);

    bt(i,:) = tm_3x3_to_1x6(B);
end
