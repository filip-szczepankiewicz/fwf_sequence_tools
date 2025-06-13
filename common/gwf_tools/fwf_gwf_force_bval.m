function [gwf, rf, dt, f] = fwf_gwf_force_bval(gwf, rf, dt, btarg, mode)
% function [gwf, rf, dt, f] = fwf_gwf_force_bval(gwf, rf, dt, btarg, mode)
% By FSz
%
% Function forces a given b-value by either scaling duration or amplitude.

b = fwf_gwf_to_bval(gwf, rf, dt);

switch mode
    case {'time', 'duration', 'dt'}
        f  = (btarg / (b+eps))^(1/3);
        dt = dt * f;
        
    case {'gamp', 'amp', 'amplitude'}
        f = sqrt(btarg/(b+eps));
        gwf = gwf * f;
end
