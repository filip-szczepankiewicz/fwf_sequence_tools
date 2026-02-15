function [gwf, rf, dt] = onescantrace(g, s, d, dp, dt)
% function [gwf, rf, dt] = fwf.gwf.create.onescantrace(g, s, d, dp, dt)

if nargin < 1
    [gwf, rf, dt] = fwf.gwf.create.heid97_orig;

else
    [gwf, rf, dt] = fwf.gwf.create.heid97_orig(g, s, d, dp, dt, 0);
    
end