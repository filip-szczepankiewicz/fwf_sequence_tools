function [gwfc, rfc, dtc, ind2] = gwf_list_from_json_v1p00(json, gamma, u, n, ind2)
% function [gwfc, rfc, dtc, ind2] = fwf.lusi.gwf_list_from_json_v2p00(json, gamma, u, n, ind2)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden
% Returns cell array of actually executed waveforms.
% Completely unvalidated.

seq              = fwf.lusi.seq_from_json(json);

[gwfo, rfo, dto] = fwf.lusi.gwf_from_seq(seq);
R3x3             = fwf.lusi.rm_from_siemens_uvec(u, seq.rot_mode, n*2*pi);

% Create normalized waveforms
bnrm   = trace(fwf.gwf.toBtensor(gwfo, rfo, dto, gamma));
wfn    = gwfo * sqrt(seq.b_max_requ*1e6/bnrm);

% Compile gwf cells with rotations and scaling
for i = 1:numel(n)
    R       = R3x3(:,:,i);
    gwfc{i} = (R * wfn')' * n(i);
    rfc{i}  = rfo;
    dtc{i}  = dto;
end
