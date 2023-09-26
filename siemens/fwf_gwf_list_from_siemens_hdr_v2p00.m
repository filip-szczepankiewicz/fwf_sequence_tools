function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr_v2p00(hdr)
% function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr_v2p00(hdr)
% By Filip Szczepankiewicz, Lund University

seq              = fwf_seq_from_siemens_hdr(hdr);
[gwfc, rfc, dtc] = fwf_gwf_from_siemens_seq_v2p00(seq);