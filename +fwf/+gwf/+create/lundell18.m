function [gwf, rf, dt] = lundell18(g, s, d, dp, dt, p1, p2, mode)
% function [gwf, rf, dt] = fwf.gwf.create.lundell18(g, s, d, dp, dt, p1, p2, mode)
%
% Lundell et al. (2018), ISMRM abstract 0887
% Spectral anisotropy in multidimensional diffusion encoding
% https://cds.ismrm.org/protected/18MPresentations/abstracts/0887.html
%
% Waveform generation implemented by Filip Szczepankiewicz, 2020-09-22
% For more info about this project, go to:
% https://github.com/filip-szczepankiewicz/Szczepankiewicz_JNeuMeth_2020
%
% Function assumes that slew rate limits only affect the ramps, but will
% throw an error if the slew rate is above limit anywhere in the waveform.
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d  is the duration of each encoding period in s
% dp is the duration of the pause in s
% dt is the time step size in s
% p1 is the number of periods on the first axis in the first period and vv
% p2 is the number of periods on the second axis in the first period and vv
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g  = 80e-3;
    s  = 100;
    d  = 98.5e-3;
    dp = 8e-3;
    dt = .1e-3;
    p1 = 1;
    p2 = 3;
    
    [gwf, rf, dt] = fwf.gwf.create.lundell18(g, s, d, dp, dt, p1, p2, 1);
    clf
    fwf.plot.wf2d(gwf, rf, dt);
    return
end

nrmp = ceil(g/s/dt)+1;
grmp = linspace(0, 1, nrmp);
grmp(end) = [];

n  = round(d/dt-2*nrmp);
np = round(dp/dt);

gz = zeros(np, 3);

% time and phase vectors
t1 = linspace(0, 2*pi, n)*p1 - pi;
t2 = linspace(0, 2*pi, n)*p2;

% dephasing q-vectors
q1 = (cos(t1)+1)/2;
q2 = sin(t2);

% gradient vectors
g1 = diff(q1);
g2 = diff(q2);

% body of waveform
ga = g1' * [1 0 0] + g2' * [0 1 0];

% ramps
gu = grmp' * ga(1,:);
gd = flip(grmp,2)' * ga(end,:);

% final section
gwf = [gu; ga; gd];


if mode == 0 % Symmetric and de-tuned
    gwf = [gwf; gz; gwf];
else % Asymmetric and tuned
    gwf = [gwf; gz; gwf(:, [2 1 3])];
end

gwf = gwf / max(abs(gwf(:))) * g;


rf = ones(size(gwf,1),1);
mind = round(size(gwf,1)/2);
rf(mind:end) = -1;


[gwf, rf, dt] = fwf.gwf.force.balance(gwf, rf, dt);
[gwf, rf, dt] = fwf.gwf.force.shape  (gwf, rf, dt, 'sym');


if any(  max(abs(diff(gwf,1)/dt),[],1) > s)
    warning('The waveform exceeds the slew rate limit!')
end

