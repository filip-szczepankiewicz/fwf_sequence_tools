function ver = ver_from_json(json)
% function ver = fwf.lusi.ver_from_json(json)
% By Patrick Fuchs
% University of Antwerp, Antwerp, Belgium
% Returns the sequnce version from the JSON field wipmemblock.
% This function is dependent on the pulse sequence version
% Completely unvalidated.

try % version < 2.00
    ver = fwf_b64_to_version(json.WipMemBlock);

    if isnan(ver)
        error('Incorrect format! Trying v2.00+')
    end

catch % version >= 2.00
    ver = json.FWF_adFree_2;

end