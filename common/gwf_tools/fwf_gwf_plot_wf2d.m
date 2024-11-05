function h = fwf_gwf_plot_wf2d(gwf, rf, dt, t)
% function h = fwf_gwf_plot_wf2d(gwf, rf, dt, t)

if nargin < 4
    t = fwf_gwf_to_time(gwf, rf, dt);
end

maxAmp = max(abs(gwf(:)));

h = plot(t*1000, gwf*1000); hold on
    plot(t*1000, rf*maxAmp/2*1000, 'k--');

ylabel('Amplitude [mT/m]')
xlabel('Time [ms]')
legend('x', 'y', 'z', 'rf')
