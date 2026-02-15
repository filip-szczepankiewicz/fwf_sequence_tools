function [gwf, rf, dt] = famedcos(gamp, dur, tp, dt)
% function [gwf, rf, dt] = fwf.gwf.create.famedcos(gamp, dur, tp, dt)
%
% Waveform design almost according to Vellmer et al. https://www.sciencedirect.com/science/article/pii/S1090780716302750

if nargin < 1
    gamp = 0.08;
    dur = 38.5e-3;
    tp = 8e-3;
    dt = 10e-6;

    [gwf, rf, dt] = fwf.gwf.create.famedcos(gamp, dur, tp, dt);

    fwf.plot.wf2d(gwf, rf, dt);
    return
end

n = round(dur/dt/2)*2; % must be divisible by 2
dur = n*dt;
m = n/2 + 1;
t = linspace(0, dur, n);

np = round(tp/dt);

p1 = cos(t/dur*pi*2);
p1(m:end) = -p1(m:end);
p2 = cos(t/dur*pi*2);


% Here we reorder the waveforms so that the unique one is along z to gain
% K-nulling.
ga = [p2' p2' p1'];
gb = [p2' -p2' p1'];
g0 = zeros(np,3);

gwf = [ga; g0; gb]*gamp;

rf = ones(size(gwf,1),1);
rf((n+round(np/2)):end) = -1;

[gwf, rf, dt] = fwf.gwf.force.balance_v2(gwf, rf, dt); 