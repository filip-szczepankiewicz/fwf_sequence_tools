function mechSpectrum(gwf, ~, dt, fInterval, tRes, dangerZone)
% function fwf.plot.mechSpectrum(gwf, ~, dt, fInterval, tRes, dangerZone)

if nargin < 1
     [gwf, rf, dt] = load_gwf5_from_lib(11);

     td = (size(gwf,1)-1)*dt;
     ns = round(td /10e-6);
     [gwf, ~, dt] = fwf.gwf.toInterpolated(gwf, rf, dt, ns);

     ts = 0.1;
     zf = zeros(round((ts-td)/10e-6), 3);

     gwf = [gwf; zf];
     gwf = repmat(gwf, 10, 1);

     clf
     fwf.plot.mechSpectrum(gwf, [], dt, [0 2000], dt*100, [500 100])
     return
end

swf = diff([gwf; 0 0 0],1,1)/dt;

% Gradient waveform power spectrum
[gps, gf] = pspectrum(gwf, 1/dt, 'power', 'FrequencyLimits', fInterval);
for i = 1:3
    [gps2d(:,:,i), gf2d, gt2d] = pspectrum(gwf(:,i), 1/dt, 'spectrogram', 'FrequencyLimits', fInterval, 'TimeResolution', tRes);
end

% d/dt of gwf (slew rate waveform) power spectrum
[sps, sf] = pspectrum(swf, 1/dt, 'power', 'FrequencyLimits', fInterval);
for i = 1:3
    [sps2d(:,:,i), sf2d, st2d] = pspectrum(swf(:,i), 1/dt, 'spectrogram', 'FrequencyLimits', fInterval, 'TimeResolution', tRes);
end


% plot
subplot(2,2,1)
plot(gf/1e3, gps/max(gps(:)))
xlabel('Frequency [kHz]')
ylabel('Power [a.u.]')
title('Average power of g(t)')

ylim([0 1.1])
xlim(fInterval/1e3)
plot_dangerzone(dangerZone)

subplot(2,2,2)
imagesc(gt2d, gf2d/1e3,  log(sum(gps2d,3)))
xlabel('Time [s]')
ylabel('Frequency [kHz]')
title('Log(Power(g(t))) vs time')

subplot(2,2,3)
plot(sf/1e3, sps/max(sps(:)))
xlabel('Frequency [kHz]')
ylabel('Power [a.u.]')
title('Average power of dg(t)/dt')

ylim([0 1.1])
xlim(fInterval/1e3)
plot_dangerzone(dangerZone)

subplot(2,2,4)
imagesc(st2d, sf2d/1e3,  log(sum(sps2d,3)))
xlabel('Time [s]')
ylabel('Frequency [kHz]')
title('Log(Power(dg(t)/dt)) vs time')
end


function plot_dangerzone(dangerZone)

if isempty(dangerZone)
    return
end

nZones = size(dangerZone,1);
mid    = dangerZone(:,1)/1e3;
bwz    = dangerZone(:,2)/1e3;

hold on

amp = get(gca, 'YLim');

for i = 1:nZones

    if all([mid(i) bwz(i)]==0)
        continue
    end

    x = mid(i) + [-1 1 1 -1]*bwz(i)/2;
    y = [[1 1]*amp(1) [1 1]*amp(2)];

    patch(x, y, [.8 .2 .2], 'facealpha', 0.3, 'linestyle', 'none');
    plot([1 1]*mid(i), amp, 'k--')
end

end