function [m, mt] = fwf_gwf_to_motion_enc(gwf, rf, dt, ml, tstart, nuc)
% function [m, mt] = fwf_gwf_to_motion_enc(gwf, rf, dt, ml, tstart)
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
    nuc = '1H';
end

t = fwf_gwf_to_time(gwf, rf, dt, tstart);

m  = zeros(numel(ml), size(gwf, 2));
mt = zeros(size(gwf, 1), size(gwf, 2), numel(ml));

gamma = fwf_gamma_from_nuc(nuc);

for i = 1:numel(ml)
    mt(:,:,i) = gamma * cumsum(gwf .* rf .* (t.^ml(i))', 1) * dt;
    m(i, :)   = mt(end,:,i);
end

