function [gwfc, rfc, dtc, tStart] = gwf_list_from_hdr_v1p00(hdr)
% function [gwfc, rfc, dtc, tStart] = fwf.silu.gwf_list_from_hdr_v1p00(hdr)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden
% Returns cell array of actually executed waveforms.
% Completely unvalidated.

seq              = fwf.silu.seq_from_hdr(hdr);
nuc              = fwf.silu.nuc_from_hdr(hdr);
tStart           = seq.t_start/1e6;

[gwfo, rfo, dto] = fwf.silu.gwf_from_seq(seq);
[~, u, n]        = fwf.silu.bvluvc_from_hdr(hdr);
R3x3             = fwf.silu.rm_from_siemens_uvec(u, seq.rot_mode, n*2*pi);

% Create normalized waveforms
bnrm   = trace(fwf.gwf.toBtensor(gwfo, rfo, dto, fwf.util.gammaFromNuc(nuc)));
wfn    = gwfo * sqrt(seq.b_max_requ*1e6/bnrm);

% Compile gwf cells with rotations and scaling
for i = 1:numel(n)
    R       = R3x3(:,:,i);
    gwfc{i} = (R * wfn')' * n(i);
    rfc{i}  = rfo;
    dtc{i}  = dto;
end