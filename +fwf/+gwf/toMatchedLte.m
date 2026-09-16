function [gwf_lte, rf, dt, v] = toMatchedLte(gwf, rf, dt)
% function [gwf_lte, rf, dt, v] = fwf.gwf.toMatchedLte(gwf, rf, dt)
% By Filip Sz
%
% This function converts STE or PTE to an LTE with matched m/b. Note that
% the input must be STE or PTE! Otherwise the b-value depends on the
% projection vector!

tmp = fwf.gwf.force.shape(gwf, rf, dt, 'sym');

xin = fwf.gwf.toXps(gwf, rf, dt);
xtm = fwf.gwf.toXps(tmp, rf, dt);

if abs(xin.b_shape-xtm.b_shape) > 0.01
    error('Input must be symmetric in B (STE or PTE)!')
end

M = gwf'*gwf;

[~, ~, R] = eig(M);

% Select diagonal projection that takes equally from all components
u = [1 1 1]'/sqrt(3); % This is equivalent across u = [+-1 +-1 +-1].
v = R*u;

gwf_lte = (gwf * v) * [1 0 0];
