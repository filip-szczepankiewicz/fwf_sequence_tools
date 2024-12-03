function [gwf, rf, dt] = fwf_gwf_create_dde_variSlew(g, s_o, s_i, d, dp, dt, u1, u2)
% function [gwf, rf, dt] = fwf_gwf_create_dde_variSlew(g, s_o, s_i, d, dp, dt, u1, u2)
%
% g  is the maximal gradient amplitude in T/m
% s_o is the outer slew rate in T/m/s
% s_i is the inner slew rate in T/m/s
% d  is the duration of the pulse pairs in s
% dp is the duration of the pause in s
% dt is the time step size in s
% uX is the direction of pulse pairs, 1x3 unit vectors
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g   = 0.08;
    s_o = 150;
    s_i = 50;
    d   = 30.5e-3;
    dt  = 1e-6;
    u1  = [1 0 0];
    u2  = [0 0 1];
    dp  = 8e-3;

    clf
    [gwf, rf, dt] = fwf_gwf_create_dde_variSlew(g, s_o, s_i, d, dp, dt, u1, u2);
    swf = [diff(gwf,1,1); 0 0 0]/dt;
    subplot(2,1,1)
    fwf_gwf_plot_wf2d(gwf, rf, dt)

    subplot(2,1,2)
    fwf_gwf_plot_wf2d(swf/1e3, rf, dt)
end

n  = round(d/dt/2);

np = round(dp/dt);
zn = zeros(np, 3);

nr_o = ceil(g/s_o/dt);
nr_i = ceil(g/s_i/dt);

if (nr_o+nr_i)>n
    % error('Specification cannot be generated!')
    fo = nr_o/(nr_o+nr_i);
    nr_o = ceil(fo*n);
    nr_i = n-nr_o;
    g = nr_o*dt*s_o;
end

wf = ones(n, 1);
wf(1:nr_o) = linspace(0,1,nr_o);
wf((end-nr_i+1):end) = linspace(1,0,nr_i);

wf = [wf(1:(end-1)); flip(-wf)];

gwf = [wf * u1; zn; wf * u2] * g;

rf = ones(size(gwf,1),1);
mind = round(size(gwf,1)/2);
rf(mind:end) = -1;



