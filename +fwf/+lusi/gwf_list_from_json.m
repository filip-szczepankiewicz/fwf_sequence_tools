function [gwfc, rfc, dtc, ind2] = gwf_list_from_json(json, gamma, u, n, ind2)
% function [gwfc, rfc, dtc, ind2] = fwf.lusi.gwf_list_from_json(json)
% By Patrick Fuchs
% University of Antwerp, Antwerp, Belgium
%
% Returns cell array of actually executed waveforms.
% Completely unvalidated.

ver = fwf.lusi.ver_from_json(json);

if ver < 2.00
    [gwfc, rfc, dtc, ind2] = fwf.lusi.gwf_list_from_json_v1p00(json, gamma, u, n, ind2);

else
    [gwfc, rfc, dtc, ind2] = fwf.lusi.gwf_list_from_json_v2p00(json, gamma, u, n, ind2);

end
