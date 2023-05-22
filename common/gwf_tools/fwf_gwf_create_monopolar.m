function [gwf, rf, dt] = fwf_gwf_create_monopolar(g, s, d, dp, dt, u)
% function [gwf, rf, dt] = fwf_gwf_create_monopolar(g, s, d, dp, dt, u)
%
% Stejskal and Tanner (1965)
% http://dx.doi.org/10.1063/1.1695690

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 16e-3;
    dp = 8e-3;
    dt = 0.1e-3;
    u = [1 0 0];

    [gwf, rf, dt] = fwf_gwf_create_monopolar(g, s, d, dp, dt, u);

    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end


n = round(d/dt);

wf1 = fwf_gwf_create_trapezoid(g, s, dt, n)';
wfz = zeros(1, round(dp/dt))';

gwf = [
    wf1*u;
    wfz*[1 1 1];
    wf1*u ];


rf = ones(size(gwf,1),1);
mind = size(wf1,1) + round(size(wfz,1)/2);
rf(mind:end) = -1;



