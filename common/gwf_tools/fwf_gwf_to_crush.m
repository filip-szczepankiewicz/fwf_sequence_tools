function cmom = fwf_gwf_to_crush(gwf, rf, dt, b, do_plot)
% function cmom = fwf_gwf_to_crush(gwf, rf, dt, b, do_plot)
% By FSz
%
% Function returns the crushing moment caused by the gwf at a given
% b-value. If do_plot, it also shows a plot of the gwf and the calculated
% crushing moment.

if nargin < 4 || isempty(b)
    b = fwf_gwf_to_bval(gwf, rf, dt);
end

if nargin < 5
    do_plot = 0;
end

g = fwf_gwf_force_bval(gwf, rf, dt, b, 'amp');

ind_pi = find(diff(rf), 1, 'first');

mom = cumsum(g.*rf,1)*dt;

cmom = sqrt(sum((mom(ind_pi,:)).^2));

if do_plot
    
    t = fwf_gwf_to_time(mom, dt);
    
    subplot(2,1,1)
    plot(t*1e3, rf*max(abs(g(:)))*0.5*1e3, 'k:')
    hold on
    
    h = plot(t*1e3, g*1e3);
    
    col = eye(3);
    for i = 1:size(gwf, 2)
        set(h(i), 'color', col(i,:)*0.9)
    end
    
    ylabel('Gradient [mT/m]')
    title(['GWF at b = ' num2str(b/1e9, '%0.2f') ' ms/µm^2'])
    
    
    subplot(2,1,2)
    h = plot(t*1e3, mom); hold on
    plot([1 1]*t(ind_pi)*1e3, [-1 1]*max(abs(mom(:))), 'k:')
    
    for i = 1:size(gwf, 2)
        set(h(i), 'color', col(i,:)*0.9)
    end
    
    plot(t*1e3, mom*0, 'k--')
    
    xlabel('Time [ms]')
    ylabel('0th-moment [T/m*s]')
    
    title(['Spoil moment = ' num2str(cmom*1e6, '%0.1e') ' (mT/m)*ms'])
    
end