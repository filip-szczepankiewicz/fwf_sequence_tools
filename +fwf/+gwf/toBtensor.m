function [bt, nbt] = toBtensor(gwf, rf, dt, gamma)
% function [bt, nbt] = fwf.gwf.toBtensor(gwf, rf, dt, gamma)
%
% gwf is n x 3 matrix in T/m defined in the gradient system
% rf is sign vector that carries info on spin dephasing direction
% dt is dwell time in s.

if nargin < 4
    gamma = fwf.util.gammaFromNuc();
end

qt  = gamma * cumsum(gwf.*rf, 1) * dt;
bt  = qt' * qt * dt;
nbt = bt/trace(bt); % normalized b-tensor, Tr(nbt) = 1.



