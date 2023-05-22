function [gwf, rf, dt] = fwf_gwf_create_onescantrace(g, s, d, dp, dt)
% function [gwf, rf, dt] = fwf_gwf_create_onescantrace(g, s, d, dp, dt)

if nargin < 1
    [gwf, rf, dt] = gwf_create_heid97_orig;

else

    [gwf, rf, dt] = gwf_create_heid97_orig(g, s, d, dp, dt, 0);
end