function [gwf, rf, dt] = fwf_gwf_create_stejskaltanner65(g, s, d, dp, dt, u)
% function [gwf, rf, dt] = fwf_gwf_create_stejskaltanner65(g, s, d, dp, dt, u)
%
% Stejskal and Tanner (1965)
% http://dx.doi.org/10.1063/1.1695690

if nargin < 1
    [gwf, rf, dt] = fwf_gwf_create_monopolar;

else
    [gwf, rf, dt] = fwf_gwf_create_monopolar(g, s, d, dp, dt, u);
    
end