function [gwf, rf, dt] = stejskaltanner65(g, s, d, dp, dt, u)
% function [gwf, rf, dt] = fwf.gwf.create.stejskaltanner65(g, s, d, dp, dt, u)
%
% Stejskal and Tanner (1965)
% http://dx.doi.org/10.1063/1.1695690

if nargin < 1
    [gwf, rf, dt] = fwf.gwf.create.monopolar;

else
    [gwf, rf, dt] = fwf.gwf.create.monopolar(g, s, d, dp, dt, u);
    
end