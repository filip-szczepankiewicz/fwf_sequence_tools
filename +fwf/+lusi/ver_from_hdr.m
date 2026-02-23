function ver = ver_from_hdr(hdr)
% function ver = fwf.lusi.ver_from_hdr(hdr)
% Returns the sequnce version from the dicom header.

csa = fwf.lusi.csa_from_hdr(hdr);
ver = fwf.lusi.ver_from_csa(csa);

