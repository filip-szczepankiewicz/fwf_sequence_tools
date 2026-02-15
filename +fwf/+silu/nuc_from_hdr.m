function nuc = nuc_from_hdr(hdr)
% function nuc = fwf.silu.nuc_from_hdr(hdr)

try
    % Before XA
    nuc = hdr.ImagedNucleus;

catch
    % After XA
    nuc = hdr.ResonantNucleus;
end