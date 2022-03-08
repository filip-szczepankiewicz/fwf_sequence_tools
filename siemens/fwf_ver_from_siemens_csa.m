function ver = fwf_ver_from_siemens_csa(csa)
% function ver = fwf_ver_from_siemens_csa(csa)
% Returns the sequnce version from the WipMemBlock.

[~, inda] = regexp(csa, 'sWipMemBlock.tFree	 = 	""');
[~, indb] = regexp(csa, 'sWipMemBlock.tFree	 = 	""\S+""');

b64str    = sscanf(csa((inda+1):indb-2), '%s');
ver       = fwf_b64_to_version(b64str);

