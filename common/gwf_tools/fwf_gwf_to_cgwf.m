function [cgwf, K, k] = fwf_gwf_to_cgwf(gwf, rf, dt, r, B0, gamma)
% function [cgwf, K, k] = fwf_gwf_to_cgwf(gwf, rf, dt, r, B0, gamma)
% By FSz
%
% Function returns the concomitant gradient waveform at position r given
% the main field strength of B0.
% The funciton also returns the K-matrix and the residual zeroth moment
% vector k as a funciton of time.
%
% See description in Szczepankiewicz et al. MRM 2019
% DOI: 10.1002/mrm.27828

if nargin < 6
    gamma = fwf_gamma_from_nuc();
end

Gx = gwf(:,1);
Gy = gwf(:,2);
Gz = gwf(:,3);

C = zeros(3,3,length(Gx));

C(1,1,:) = Gz.*Gz;
C(1,2,:) = 0;
C(1,3,:) = -2*Gx.*Gz;
C(2,1,:) = 0;
C(2,2,:) = Gz.*Gz;
C(2,3,:) = -2*Gy.*Gz;
C(3,1,:) = C(1,3,:);
C(3,2,:) = C(2,3,:);
C(3,3,:) = 4*(Gx.*Gx + Gy.*Gy);

cgwf = nan(size(gwf));
K    = nan(size(C));

for i = 1:size(C,3)
    cgwf(i,:) = (C(:,:,i)*r)'/(4*B0);
    K (:,:,i) = C(:,:,i) * rf(i) * gamma / 2 / pi * dt / (4*B0);
end

% Concomitant moment vector aafo time
k = cumsum(cgwf .* rf * gamma / 2 / pi * dt);