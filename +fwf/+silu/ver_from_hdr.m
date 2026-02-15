function ver = ver_from_hdr(hdr)
% function ver = fwf.silu.ver_from_hdr(hdr)
% Returns the sequnce version from the dicom header.

csa = fwf.silu.csa_from_hdr(hdr);
ver = fwf.silu.ver_from_csa(csa);

