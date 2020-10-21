function g = fwf_gwf_to_scaled_gwf(gwf, rf, dt, b)
% function g = fwf_gwf_to_scaled_gwf(gwf, rf, dt, b)
% By Arthur Chakwizira
% Lund University, Sweden
% returns a 1D gradient waveform scaled to the b-value b


q = gwf_to_q(gwf, rf, dt);
q = q(:,~all(q==0, 1));
%Determine current b-value
b_value = gwf_b_from_q(q', dt);
%Compute scaling factor
g_scale = sqrt(b/b_value);
%Scale input waveform
g = g_scale*gwf;
