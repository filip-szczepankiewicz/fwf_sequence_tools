function [gwfc, rfc, dtc, ind2] = fwf_gwf_list_from_siemens_hdr(hdr)
% function [gwfc, rfc, dtc, ind2] = fwf_gwf_list_from_siemens_hdr(hdr)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden
% Returns cell array of actually executed waveforms.
% Completely unvalidated.


seq                   = fwf_seq_from_siemens_hdr(hdr);
[gwfo, rfo, dto, ind] = fwf_gwf_from_siemens_seq(seq);
[~, u, n, ind2]       = fwf_bvluvc_from_siemens_hdr(hdr, ind);
R3x3                  = fwf_rm_from_siemens_uvec(u, seq.rot_mode, n*2*pi);


% Create normalized waveforms
for i = 1:numel(gwfo)
    bnrm   = trace(fwf_bt_from_gwf(gwfo{i}, rfo{i}, dto{i}, fwf_gamma_from_nuc(hdr.ImagedNucleus)));
    wfn{i} = gwfo{i} * sqrt(seq.b_max_requ*1e6/bnrm);
end

% Compile gwf cells with rotations and scaling
for i = 1:numel(n)
    R       = R3x3(:,:,i);
    gwfc{i} = (R * wfn{ind2(i)}')' * n(i);
    rfc{i}  = rfo{ind2(i)};
    dtc{i}  = dto{ind2(i)};
end