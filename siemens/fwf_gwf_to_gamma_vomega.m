function [gam, vom] = fwf_gwf_to_gamma_vomega(gwf, rf, dt, xps)
% function [gam, vom] = fwf_gwf_to_gamma_vomega(gwf, rf, dt, xps)
% By Arthur Chakwizira
% Lund University, Sweden
% returns the following exchange- and restriction- weighting parameters:
% Gamma (from Ning L et al. (2018))
% Vomega (from Nilsson M et al. (2017))
% The parameters are calculated at the maximum b-value

%extract 1D waveform and q-trajectory
gwf = gwf(:,~all(gwf==0, 1));
if ~iscolumn(gwf)
    error(strcat('Expected Nx1 waveform, got', num2str(size(gwf,1)), 'x', num2str(size(gwf,2))))
end
g = fwf_gwf_to_scaled_gwf(gwf, rf, dt, max(xps.b));
q = gwf_to_q(g, rf, dt);
q = q(:,~all(q==0, 1));

%define time vector
Nt = size(gwf, 1);
t = (0:dt:(Nt-1)*dt)';

%compute Vomega
vom = (1/max(xps.b))*msf_const_gamma()^2*trapz(t, g.^2);
%Compute q4 (4th order autocorrelation function of q)
q4 = (1/max(xps.b)^2)*fwf_q4_from_q(q, dt);
%compute Gamma
gam = 2*trapz(t, t.*q4);
