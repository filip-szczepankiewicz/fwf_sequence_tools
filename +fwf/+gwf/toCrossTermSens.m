function [c, ct, H] = toCrossTermSens(gwf, rf, dt)
% function [c, ct, H] = fwf.gwf.toCrossTermSens(gwf, rf, dt)

qt = gwf_to_q(gwf, rf, dt);

H  = cumsum(rf)*dt*msf_const_gamma; % [1/T]
ct = cumsum(qt.*H)*dt; % [s/m/T]

% Final value
c = ct(end,:); % [s/m/T]
