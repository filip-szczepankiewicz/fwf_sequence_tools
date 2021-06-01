function [bt, nbt] = fwf_bt_from_gwf(gwf, rf, dt, gamma)
% function [bt, nbt] = fwf_bt_from_gwf(gwf, rf, dt, gamma)
%
% gwf is n x 3 matrix in T/m defined in the gradient system
% rf is sign vector that carries info on spin dephasing direction
% dt is dwell time in s.

if nargin < 4
    gamma = 2.6751e+08;
end

g_eff = gwf .* rf;

q = gamma * cumsum( g_eff, 1 ) * dt;

bt = q' * q * dt;

nbt = bt/trace(bt); % normalized b-tensor, Tr(nbt) = 1.