function [bvals, g_sca] = fwf_blist_from_seq_siemens(seq)
% function [bvals, g_sca] = fwf_blist_from_seq_siemens(seq)
% By Filip Szczepankiewicz, Lund University

nbval = numel(seq.bval_req);
navgs = seq.avgs_req;

% Construct order of b-values executed by scanner. This is reverse
% engineered and may be wrong *although it is tested*.

bvals = nan(max(navgs), nbval);
for i = 1:nbval
    bvals(1:navgs(i),i) = seq.bval_req(i);
end

bvals = bvals';
bvals = bvals(:);
bvals = bvals(~isnan(bvals));
g_sca = sqrt(bvals/max(bvals));