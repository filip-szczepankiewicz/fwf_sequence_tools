function [m, M] = fwf_gwf_to_maxwellIndex(gwf, rf, dt)
% function [m, M] = fwf_gwf_to_maxwellIndex(gwf, rf, dt)
% 
% Maxwell matrix and index from Szczepankiewicz et al. 10.1002/mrm.27828

M = mtimes(gwf', (gwf.*rf))*dt; % Eq. 15
m = norm(M, 'fro');             % Eq. 14 = sqrt(trace(M*M))
