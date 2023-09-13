function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr(hdr)
% function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr(hdr)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden
% Returns cell array of actually executed waveforms.
% Completely unvalidated.

seq = fwf_seq_from_siemens_hdr(hdr);

if seq.seq_ver < 2.00
    [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr_v1p00(hdr);

else
    [gwfc, rfc, dtc] = fwf_gwf_from_siemens_seq(seq);

end