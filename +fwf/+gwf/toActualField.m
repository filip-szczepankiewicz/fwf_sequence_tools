function B_a = fwf_gwf_to_B_actual(gwf, B0, r, a, f)
% function B_a = fwf_gwf_to_B_actual(gwf, B0, r, a, f)
%
% This is the approximation of the b-field according to Bernstein et al. 1998 
% Eq. A10.

B_a = [
        f*r(2) + gwf(:,1)*r(3) - a*gwf(:,3)*r(1), ...
        f*r(1) + gwf(:,2)*r(3) + gwf(:,3)*r(2)*(a - 1), ...
        B0 + gwf(:,1)*r(1) + gwf(:,2)*r(2) + gwf(:,3)*r(3)
      ];