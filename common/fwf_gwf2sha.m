function sha = fwf_gwf2sha(gwf)
% function sha = fwf_gwf2sha(gwf)
%
% This function seems consistend regardless of input precision, i.e.
% fwf_gwf2sha(single(gwf)) = fwf_gwf2sha(double(gwf))
%
% This function was copied from the safe PNS model repo:
% https://github.com/filip-szczepankiewicz/safe_pns_prediction (safe_hw_to_sha)
% so thanks again to Maxim Zaitsev who helped with the Java variant.

import java.security.*;
import java.math.*;
import java.lang.String;

md   = MessageDigest.getInstance('SHA-256');
hash = md.digest(double(gwf(:))); % use this in bin file? 32 x int8
bi   = BigInteger(1, hash);
sha  = char(String.format('%064X', bi)); % or this 64 x char