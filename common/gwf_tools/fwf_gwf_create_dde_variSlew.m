function [gwf, rf, dt] = fwf_gwf_create_dde_variSlew(g, s_o, s_i, d, dp, dt, u1, u2)
% function [gwf, rf, dt] = fwf_gwf_create_dde_variSlew(g, s_o, s_i, d, dp, dt, u1, u2)
%
% g is gradient amplitude
% s_o and s_i are the outer and inner slew rates


n  = round(d/dt/2);

np = round(dp/dt);
zn = zeros(np, 3);

nr_o = ceil(g/s_o/dt);
nr_i = ceil(g/s_i/dt);

if (nr_o+nr_i)>n
    error('Specification cannot be generated!')
end

wf = ones(n, 1);
wf(1:nr_o) = linspace(0,1,nr_o);
wf((end-nr_i+1):end) = linspace(1,0,nr_i);

wf = [wf(1:(end-1)); flip(-wf)];

gwf = [wf * u1; zn; wf * u2] * g;

rf = ones(size(gwf,1),1);
mind = round(size(gwf,1)/2);
rf(mind:end) = -1;



