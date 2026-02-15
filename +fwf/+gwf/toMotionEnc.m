function [m, mt] = toMotionEnc(gwf, rf, dt, ml, tstart, gamma)
% function [m, mt] = fwf.gwf.toMotionEnc(gwf, rf, dt, ml, tstart, gamma)
% By Fsz
% 
% Funciton returns motion encoding trajectories for moments specified in
% the moment list ml. m is the final moment, and mt is the temporal
% trajectory.
%
% Output orientation is order-by-xyz (numel(ml) x 3)
% 
if nargin < 5
    tstart = 0;
end

if nargin < 6
    gamma = fwf.util.gammaFromNuc();
end

t = fwf.gwf.toTime(gwf, rf, dt, tstart);

m  = zeros(numel(ml), size(gwf, 2));
mt = zeros(size(gwf, 1), size(gwf, 2), numel(ml));

for i = 1:numel(ml)
    mt(:,:,i) = gamma * cumsum(gwf .* rf .* (t.^ml(i))', 1) * dt;
    m(i, :)   = mt(end,:,i);
end

