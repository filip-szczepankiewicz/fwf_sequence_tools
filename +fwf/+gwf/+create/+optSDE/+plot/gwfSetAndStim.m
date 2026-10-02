function gwfSetAndStim(gwf, rf, dt, hw)
% function optMono.plot.gwfSetAndStim(gwf, rf, dt, hw)

gwf = gwf(:,1) .* [1 1 1];
xps = fwf.gwf.toXps(gwf, rf, dt);

h = 3;
w = numel(hw);

subplot(h, 1, 1)
fwf.plot.wf2d(gwf, rf, dt)
title(['LTE (gmax = ' num2str(max(abs(gwf(:)*1e3)),'%.1f') ' mT/m) with ' ...
    'b = '          num2str(xps.b/1e9,  '%.2f' ) ' ms/µm^2']);

subplot(h,1,2)
fwf.plot.wf2d(diff([0 0 0; gwf],1,1)/dt/1e3, rf, dt)
ylabel('Slew rate [T/m/s]')

for j = 1:w
    ns = safe_gwf_to_pns(gwf, rf, dt, hw(j), 0);

    subplot(h, w, 2*w+1 + (j-1))
    safe_plot(ns, dt)
    title([hw(j).model ' stimulation (' num2str(max(ns(:)),'%.1f') '%)'])
    legend off
end