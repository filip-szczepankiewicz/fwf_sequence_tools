function [gwfc, rfc, dtc] = fwf_gwf_from_siemens_seq_v2p00(seq, bin_fn)
% function [gwfc, rfc, dtc] = fwf_gwf_from_siemens_seq_v2p00(seq, bin_fn)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden

if nargin < 2 || isempty(bin_fn)
    bin_fn = fwf_bin_from_sha(seq.gwf_sha);
end

dt = 10e-6; % or seq.grad_raster/1e6;

wf_parts = fwf_bin_read_siemens(bin_fn);

na = size(wf_parts{1,1},1);
nb = size(wf_parts{2,1},1);
nz = seq.d_pause / 10;
ns = round(seq.t_start*1e-6/dt);
nt = round(seq.te/1e3/dt);

gs = zeros(ns, 3);
gp = zeros(nz, 3);
ge = zeros(nt-ns-na-nz-nb, 3);

rf = ones(nt,1);
rf(round(nt/2):end) = -1;

for i = 1:size(wf_parts,2)
    gwfc{i} = [gs; wf_parts{1,i}; gp; wf_parts{2,i}; ge];
    rfc{i}  = rf;
    dtc{i}  = dt;
end






