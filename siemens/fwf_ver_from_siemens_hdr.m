function ver = fwf_ver_from_siemens_hdr(hdr)
% function ver = fwf_ver_from_siemens_hdr(hdr)
% Returns the sequnce version from the WipMemBlock.

csa = fwf_csa_from_siemens_hdr(hdr);
ver = fwf_ver_from_siemens_csa(csa);




