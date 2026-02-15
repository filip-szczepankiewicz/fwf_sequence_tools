function [gwf, rfc, dtc, tStart] = gwf_from_seq_v2p00(seq, bin_fn)
% function [gwf, rfc, dtc, tStart] = fwf.silu.gwf_from_seq_v2p00(seq, bin_fn)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden

if nargin < 2 || isempty(bin_fn)
    bin_fn = fwf.silu.bin_from_sha(seq.bin_hash);
end

dt     = seq.d_grad_rast*1e-6; % s
tStart = seq.t_start/1e6;

wf_parts = fwf.silu.bin_read(bin_fn);

na = size(wf_parts{1,1},1);
nb = size(wf_parts{2,1},1);
nz = round(seq.d_pause*1e-6/dt);
ns = round(seq.t_start*1e-6/dt);
nt = round(seq.te*1e-3/dt);

gs = zeros(ns, 3);
gp = zeros(nz, 3);
ge = zeros(nt-ns-na-nz-nb, 3);

rf = ones(nt,1);
rf(round(nt/2):end) = -1;

[bvals, g_sca] = fwf.silu.blist_from_seq(seq);

g_max = seq.gamp_max*1e-3;

if isempty(g_max)
    g_max = sqrt(max(bvals)/seq.max_b_per_g2)*1e-3;
end

c = 1;
for j = 1:numel(bvals)
    if bvals(j) == 0 % b0 images are repeated only once
        gwf{c} = [gs; wf_parts{1,1}; gp; wf_parts{2,1}; ge]*0;
        rfc{c} = rf;
        dtc{c} = dt;
        c = c+1;
    else
        for i = 1:size(wf_parts,2)
            gwf{c} = [gs; wf_parts{1,i}; gp; wf_parts{2,i}; ge] * g_max * g_sca(j);
            rfc{c} = rf;
            dtc{c} = dt;
            c = c+1;
        end
    end
end




