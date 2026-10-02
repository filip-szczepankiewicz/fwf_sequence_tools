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

% Original equation from Matlab
% gwf_a = [(2.*gwf(:,1).*(B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)) + 2.*f.*(f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)) - 2.*a.*gwf(:,3).*(f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)))./(2.*((f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)).^2 + (B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)).^2 + (f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)).^2).^(1./2)), ...
%          (2.*gwf(:,2).*(B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)) + 2.*f.*(f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)) + 2.*gwf(:,3).*(a - 1).*(f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)))./(2.*((f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)).^2 + (B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)).^2 + (f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)).^2).^(1./2)), ...
%          (2.*gwf(:,3).*(B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)) + 2.*gwf(:,1).*(f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)) + 2.*gwf(:,2).*(f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)))./(2.*((f.*r(1) + gwf(:,2).*r(3) + gwf(:,3).*r(2).*(a - 1)).^2 + (B0 + gwf(:,1).*r(1) + gwf(:,2).*r(2) + gwf(:,3).*r(3)).^2 + (f.*r(2) + gwf(:,1).*r(3) - a.*gwf(:,3).*r(1)).^2).^(1./2))];


% Manual simplification 1
% gx = gwf(:,1);
% gy = gwf(:,2);
% gz = gwf(:,3);
% x = r(1);
% y = r(2);
% z = r(3);
% 
% ST = [
%     f.*(f*x+gy*z+gz*y*(a-1)) - a.*     gz.*(f*y+gx*z-gz*x*a    ), ...
%     f.*(f*y+gx*z-gz*x*a    ) + (a-1).* gz.*(f*x+gy*z+gz*y*(a-1)), ...
%                                        gx.*(f*y+gx*z-gz*x*a    ) + ...
%                                        gy.*(f*x+gy*z+gz*y*(a-1))
%     ];
% 
% DE = sqrt(Bd.^2 + (f*x+gy*z+gz*y*(a-1)).^2 + (f*y+gx*z-a*gz*x).^2 );
% gwf_a = (gwf.*Bd + ST) ./ DE;


% Manual simplification 2
% See supplementary material in paper
if numel(r)~=3
    error('Position vector must have three elements')
end

n  = size(gwf,1);
Bd = B0 + gwf * r';
v  = [-a*gwf(:,3)       f*ones(n,1)   gwf(:,1)];
w  = [ f*ones(n,1)  (a-1)*gwf(:,3)    gwf(:,2)];

% Numerator is something like E .* [gwf; A; B], and the denominator is the
% norm |E|, where E = [Bd, A*r', B*r'].

gwf_a = (Bd.*gwf + v.*(v*r') + w.*(w*r')) ./ sqrt(Bd.^2 + (v*r').^2 + (w*r').^2);