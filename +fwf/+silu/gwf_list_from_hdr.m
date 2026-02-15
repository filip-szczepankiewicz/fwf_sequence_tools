function [gwfc, rfc, dtc, tStart] = gwf_list_from_hdr(hdr)
% function [gwfc, rfc, dtc, tStart] = fwf.silu.gwf_list_from_hdr(hdr)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden
% Returns cell array of actually executed waveforms.
% This code is not tested for all cases so be careful!

ver = fwf.silu.ver_from_hdr(hdr);

if ver < 2.00
    [gwfc, rfc, dtc, tStart] = fwf.silu.gwf_list_from_hdr_v1p00(hdr);

else
    [gwfc, rfc, dtc, tStart] = fwf.silu.gwf_list_from_hdr_v2p00(hdr);

end