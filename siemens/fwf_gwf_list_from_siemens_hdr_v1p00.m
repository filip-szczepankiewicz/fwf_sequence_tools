function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr_v1p00(hdr)
% function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr_v1p00(hdr)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden
% Returns cell array of actually executed waveforms.
% Completely unvalidated.

seq              = fwf_seq_from_siemens_hdr(hdr);

[gwfo, rfo, dto] = fwf_gwf_from_siemens_seq(seq);
[~, u, n]        = fwf_bvluvc_from_siemens_hdr(hdr);
R3x3             = fwf_rm_from_siemens_uvec(u, seq.rot_mode, n*2*pi);
nuc              = fwf_nuc_from_siemens_hdr(hdr);

% Create normalized waveforms
bnrm   = trace(fwf_gwf_to_btens(gwfo, rfo, dto, fwf_gamma_from_nuc(nuc)));
wfn    = gwfo * sqrt(seq.b_max_requ*1e6/bnrm);

% Compile gwf cells with rotations and scaling
for i = 1:numel(n)
    R       = R3x3(:,:,i);
    gwfc{i} = (R * wfn')' * n(i);
    rfc{i}  = rfo;
    dtc{i}  = dto;
end