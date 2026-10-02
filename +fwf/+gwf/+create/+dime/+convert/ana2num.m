function [gwf_out, rf_out, dt_out, t_out] = ana2num(gwf, t, dt)
% function [gwf_out, rf_out, dt_out, t_out] = dime.convert.ana2num(gwf, t, dt)
% By Filip Szczepankiewicz, Lund University
%
% Convert analytic (piecewise linear) control point in time to a numerical
% variant that can be evaluated wrt nerve stimulation and loaded onto the
% scanner.

n_out = round(range(t(:))/dt);
t_out = linspace(min(t(:)), max(t(:)), n_out)';
dt_out = t_out(2)-t_out(1);

nAx = size(gwf,2);

gwf_out = zeros(numel(t_out), nAx);

for i = 1:nAx
    [ut, ui] = unique(t(:,i));
    gwf_out(:,i) = interp1(ut, gwf(ui,i), t_out);
end

rf_out = ones(size(gwf_out,1),1); 
rf_out(round(size(rf_out,1)/2):end)=-1;

gwf_out(isnan(gwf_out)) = 0;
gwf_out = gwf_out.*rf_out;