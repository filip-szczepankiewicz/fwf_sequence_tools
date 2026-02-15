function [m, M] = toMaxwellInd(gwf, rf, dt)
% function [m, M] = fwf.gwf.toMaxwellInd(gwf, rf, dt)
% 
% Maxwell matrix and index from Szczepankiewicz et al. 10.1002/mrm.27828

M = (gwf.*rf)' * gwf * dt; % Eq. 15, inner product, integrated
m = sqrt(trace(M*M));      % Eq. 14, Frobenius norm
