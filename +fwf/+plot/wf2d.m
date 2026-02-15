function h = fwf_gwf_plot_wf2d(gwf, rf, dt, t, col, ls)
% function h = fwf_gwf_plot_wf2d(gwf, rf, dt, t, ls)

if nargin < 4 || isempty(t)
    t = fwf.gwf.toTime(gwf, rf, dt);
end

if nargin < 5
    col = [1 0 0; 0 1 0; 0 0 1; 0 0 0]*0.7+0.3;
end

if nargin < 6
    ls  = {'-', '-', '-', '-'};
end

maxAmp = max(max(abs(gwf(:,1:max(size(gwf,3),3)))));




hold on

for i = 1:max(size(gwf, 2), 3)

    if i<4
        y = gwf(:,i)*1000;
    else
        y = real(gwf(:,i));
        y = y/max(abs(y))*maxAmp/2*1000;
    end

    h(i) = plot(t*1000, y, 'color', col(i,:), 'LineStyle', ls{i});
end

h(i+1) = plot(t*1000, rf*maxAmp/sqrt(2)*1000, 'k--');

ylabel('Amplitude [mT/m]')
xlabel('Time [ms]')
legend('x', 'y', 'z', 'rf')
