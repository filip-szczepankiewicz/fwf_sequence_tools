function [gwf, rf, dt] = dde_customramp(g, s_o, s_i, d, dp, dt, u1, u2, sf)
% function [gwf, rf, dt] = fwf.gwf.create.dde_customramp(g, s_o, s_i, d, dp, dt, u1, u2, sf)
%
% By Filip Sz, LU
%
% g  is the maximal gradient amplitude in T/m
% s_o is the outer slew rate in T/m/s
% s_i is the inner slew rate in T/m/s
% d  is the duration of the pulse pairs in s
% dp is the duration of the pause in s
% dt is the time step size in s
% uX is the direction of pulse pairs, 1x3 unit vectors
% If no input, create example gwf at approximately b2000 and 80 mT/m.
% sf is the slew factor that is requested at the highest amplitudes. E.g.,
% if sf is 0, the ramp will be a sine function between 0 and pi/2 with
% derivateive 1 and 0 at either point.
% Note that sf must be in the interval [0 1)

if nargin < 1
    g   = 0.08;
    s_o = 100;
    s_i = 100;
    d   = 30.5e-3;
    dt  = 1e-6;
    u1  = [1 0 0];
    u2  = [0 0 1];
    dp  = 8e-3;
    sf  = 0.5;

    clf
    [gwf, rf, dt] = fwf.gwf.create.dde_customramp(g, s_o, s_i, d, dp, dt, u1, u2, sf);
    swf = [diff(gwf,1,1); 0 0 0]/dt;
    subplot(2,1,1)
    fwf.plot.wf2d(gwf, rf, dt)

    subplot(2,1,2)
    fwf.plot.wf2d(swf/1e3, rf, dt)
    ylabel('Slew rate [T/m/s]')
end

if sf >= 1 || sf < 0
    error('Slew factor (sf) must be in the interval [0 1)!')
end

n  = round(d/dt/2);

np = round(dp/dt);
zn = zeros(np, 3);

f_o = s_o/g;
f_i = s_i/g;

tf = acos(sf)/pi*2;

tr_o = pi/2/f_o*tf;
tr_i = pi/2/f_i*tf;

nr_o = ceil(tr_o/dt/sin(tr_o*f_o)+0.5);
nr_i = ceil(tr_i/dt/sin(tr_i*f_i)+0.5);

if (nr_o+nr_i)>n
    % error('Specification cannot be generated!')
    fo = nr_o/(nr_o+nr_i);
    nr_o = ceil(fo*n);
    nr_i = n-nr_o;
    g = nr_o*dt*s_o;
end

wf  = ones(n, 1);

t_o = linspace(0, tr_o, nr_o);
t_i = linspace(tr_i, 0, nr_i);

g_o = sin(t_o*f_o) / sin(tr_o*f_o);
g_i = sin(t_i*f_i) / sin(tr_i*f_i);

wf(1:nr_o) = g_o;
wf((end-nr_i+1):end) = g_i;

wf = [wf(1:(end-1)); flip(-wf)];

gwf = [wf * u1; zn; wf * u2] * g;

rf = ones(size(gwf,1),1);
mind = round(size(gwf,1)/2);
rf(mind:end) = -1;

