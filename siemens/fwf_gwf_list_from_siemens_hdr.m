function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr(hdr)
% function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr(hdr)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden
% Returns cell array of actually executed waveforms.
% This code is not tested for all cases so be careful!

ver = fwf_ver_from_siemens_hdr(hdr);

if ver < 2.00
    [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr_v1p00(hdr);

else
    [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr_v2p00(hdr);

end