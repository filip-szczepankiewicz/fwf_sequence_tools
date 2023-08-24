function [sha, ui8] = fwf_gwf2sha(gwf, ver)
% function [sha, ui8] = fwf_gwf2sha(gwf, ver)
%
% This funciton returns a 1x64 char array (128 bytes) that is unique for
% the waveform. Note that it is sensitive to the precision specified, and
% that it is also perturbed by the optional version parameter.

if nargin < 2
    ver = [];
end

import java.security.*;
import java.math.*;
import java.lang.String;

md   = MessageDigest.getInstance('SHA-256');
arr  = typecast([double(gwf(:)); double(ver)], 'uint8');
hash = typecast(md.digest(arr), 'uint8');
sha  = char(String.format('%064X', BigInteger(1, hash))); 
ui8  = cast(sha, 'uint8'); % Cast for storage in bin. Note: char(ui8) = sha