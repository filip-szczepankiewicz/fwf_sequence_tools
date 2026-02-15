function [Gamma, q4t] = fwf_gwf_to_tex(gwf, rf, dt, opt)
% function [Gamma, q4t] = fwf_gwf_to_tex(gwf, rf, dt, opt)
%
% Compute a generalized exchange time
%
% This time is probably a fourth order tensor, but here we just compute its
% three orthogonal projections

if (nargin < 4), opt.do_interpolate = 1; end

gwf_check(gwf, rf, dt);

% scale up waveforms to get more accurate integrations
if (dt > 1e-4) && (opt.do_interpolate ~= 0)
    [gwf,rf,dt] = gwf_interpolate(gwf,rf,dt,16);
end

q  = gwf_to_q(gwf, rf, dt);
bt = gwf_to_bt(gwf, rf, dt);

q4t = zeros(size(gwf,1), 3);
for c = 1:size(gwf,2)
    
    q2 = q(:,c).^2;
    q4 = xcorr(q2,q2) * dt;
    q4 = [0; q4((numel(q2)+1):end)];
    q4 = q4 / (bt(c,c)^2 + eps);
    
    t = (1:numel(q4))' * dt - dt; % start axes from zero
    q4t(:,c) = q4 .* t;
    
end

Gamma = 3 * 2 * sum(q4t,1) * dt;
    


