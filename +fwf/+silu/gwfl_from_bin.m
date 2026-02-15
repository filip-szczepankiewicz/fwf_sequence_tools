function [gwfl, rfl, dtl] = fwf_gwfl_from_bin_siemens(bin_fn, gamp, t_pause, dt)
% function [gwfl, rfl, dtl] = fwf_gwfl_from_bin_siemens(bin_fn, gamp, t_pause, dt)
%
% NOTE: This function does not include the effect of averages and multiple
% b-values, so it only coarsly depicts what is acquired by the scanner.

GWF = fwf_bin_read_siemens(bin_fn);

n_wf  = size(GWF,2);

na = size(GWF{1,1},1);
nb = size(GWF{2,1},1);

nz  = round(t_pause/dt);
nz1 = round(nz/2);
nz2 = nz-nz1;

rf = [ones(na+nz1,1); -ones(nb+nz2,1)];

for i = 1:n_wf
    gwfl{i}  = [GWF{1,i}; zeros(nz,3); GWF{2,i}] * gamp;
    rfl{i} = rf;
    dtl{i} = dt;
end