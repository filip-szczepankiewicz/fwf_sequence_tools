function nuc = fwf_nuc_from_siemens_hdr(hdr)
% function nuc = fwf_nuc_from_siemens_hdr(hdr)

try
    % Before XA
    nuc = hdr.ImagedNucleus;

catch
    % After XA
    nuc = hdr.ResonantNucleus;
end