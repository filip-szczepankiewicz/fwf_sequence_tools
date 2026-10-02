function m = par2mval(amp, tru, trd, ftt)
% function m = par2mval(amp, tru, trd, ftt)
% 
% Calculate the per-axis component of the m-tensor.

m = amp^2 * (2*tru/3 + 2*ftt + 2*trd/3);