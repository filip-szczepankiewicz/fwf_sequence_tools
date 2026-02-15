function [gwf, rf, dt] = hao25(g, s, d, dt, dp)
% function [gwf, rf, dt] = fwf.gwf.create.hao25(g, s, d, dt, dp)
%
% This is not a fully accurate generator!!! Just used for some testing.
% 
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d  is the duration of the first pulse pair s
% dp is the duration of the pause in s
% dt is the time step size in s
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g = 0.08;
    s = 100;
    d = 69e-3;
    dt = 1e-4;
    dp = 8e-3;

    [gwf, rf, dt] = fwf.gwf.create.hao25(g, s, d, dt, dp);

    clf
    fwf.plot.wf2d(gwf, rf, dt);
    return
end

g1 = fwf.gwf.create.ogse(g, s, d, 0, dt, 5);
g1 = g1(1:(size(g1,1)/2),1);

ns = round(size(g1,1)/8);
gs = zeros(ns,1);
np = round(dp/dt);
gp = zeros(round(dp/dt),3);


gx = [g1; gs];
gy = [gs; g1];

ga = [gx gy gy*0];
gb = gx.*[0 0 1];

gwf = [ga; gp; gb];

rf = ones(size(gwf,1),1);
rf(round(size(ga,1)+np/2):end) = -1;

na = size(ga,1);
g2 = fwf.gwf.create.ogse(g, 200, na*dt, 0, dt, 25); % This suffers from rounding issues... perhaps should be implemented in analytical form
g2 = g2(1:(size(g2,1)/2),1);

nz2 = zeros(size(gwf,1)-2*size(g2,1),3);

gwf2 = [g2.*[0 0 1]; nz2; g2.*[1 1 0]];

gwf = gwf+gwf2;