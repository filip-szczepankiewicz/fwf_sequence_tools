function [gwfc, rfc, dtc, tStart] = gwf_list_from_hdr_v2p00(hdr)
% function [gwfc, rfc, dtc, tStart] = fwf.lusi.gwf_list_from_hdr_v2p00(hdr)
% By Filip Szczepankiewicz, Lund University

seq                      = fwf.lusi.seq_from_hdr(hdr);
[gwfc, rfc, dtc, tStart] = fwf.lusi.gwf_from_seq_v2p00(seq);