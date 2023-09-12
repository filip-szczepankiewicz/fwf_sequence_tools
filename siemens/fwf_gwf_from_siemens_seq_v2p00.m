function [gwf, rfc, dtc] = fwf_gwf_from_siemens_seq_v2p00(seq, bin_fn)
% function [gwf, rfc, dtc] = fwf_gwf_from_siemens_seq_v2p00(seq, bin_fn)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden

if nargin < 2 || isempty(bin_fn)
    bin_fn = fwf_bin_from_sha(seq.bin_hash);
end

dt = seq.d_grad_rast*1e-6; % s

wf_parts = fwf_bin_read_siemens(bin_fn);

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

nbval = numel(seq.bval_req);
navgs = seq.avgs_req;


% Construct order of b-values executed by scanner. This is reverse
% engineered and highly prone to error.
blist = nan(max(navgs), nbval);
for i = 1:nbval
    blist(1:navgs(i),i) = seq.bval_req(i);
end

blist = blist';
blist = blist(:);
blist = blist(~isnan(blist));
g_sca = sqrt(blist/max(blist));

c = 1;
for j = 1:numel(blist)
    if blist(j) == 0 % b0 images are repeated only once
        gwf{c} = [gs; wf_parts{1,1}; gp; wf_parts{2,1}; ge]*0;
        rfc{c} = rf;
        dtc{c} = dt;
        c = c+1;
    else
        for i = 1:size(wf_parts,2)
            gwf{c} = [gs; wf_parts{1,i}; gp; wf_parts{2,i}; ge] * seq.gamp_max * g_sca(j);
            rfc{c} = rf;
            dtc{c} = dt;
            c = c+1;
        end
    end
end




