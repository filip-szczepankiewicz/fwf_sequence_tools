function [gwf_a, rf, dt] = toActual(gwf, rf, dt, r, B0, a, f)
% function [gwf_a, rf, dt] = fwf.gwf.toActual(gwf, rf, dt, r, B0, a, f)
% 
% By Filip Sz
% Part of AMC project
%
% r  is the position vector in meters
% B0 is the main magnetic field strength in Tesla
% a  is the assymetry factor in units of 1.
% f  is the additional non-Maxwell contribution in T/m

gwf_a = [(2.*gwf(:,1).*(B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)) + 2.*f.*(f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)) - 2.*a.*gwf(:,3).*(f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)))./(2.*((f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)).^2 + (B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)).^2 + (f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)).^2).^(1./2)), ...
         (2.*gwf(:,2).*(B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)) + 2.*f.*(f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)) + 2.*gwf(:,3).*(a - 1).*(f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)))./(2.*((f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)).^2 + (B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)).^2 + (f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)).^2).^(1./2)), ...
         (2.*gwf(:,3).*(B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)) + 2.*gwf(:,1).*(f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)) + 2.*gwf(:,2).*(f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)))./(2.*((f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)).^2 + (B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)).^2 + (f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)).^2).^(1./2))];
