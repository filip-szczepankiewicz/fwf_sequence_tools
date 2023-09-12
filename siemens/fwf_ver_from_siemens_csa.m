function ver = fwf_ver_from_siemens_csa(csa)
% function ver = fwf_ver_from_siemens_csa(csa)
% Returns the sequnce version from the CSA header wipmemblock.
% This function is dependent on the pulse sequence version

try % version < 2.00
    [~, inda] = regexp(csa, 'sWipMemBlock.tFree	 = 	""');
    [~, indb] = regexp(csa, 'sWipMemBlock.tFree	 = 	""\S+""');

    b64str    = sscanf(csa((inda+1):indb-2), '%s');
    ver       = fwf_b64_to_version(b64str);

    if isnan(ver)
        error('Incorrect format! Trying v2.00+')
    end

catch % version >= 2.00
    [~,ind] = regexp(csa, 'sWipMemBlock.adFree\[2\]\s*=');
    ver = sscanf(csa((ind+1):end), '%g', [1 inf]);

end