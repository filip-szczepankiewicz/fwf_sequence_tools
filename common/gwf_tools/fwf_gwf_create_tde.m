function [gwf, rf, dt] = fwf_gwf_create_tde(g, s, d, dp, dt)
% function [gwf, rf, dt] = fwf_gwf_create_tde(g, s, d, dp, dt)
% 
% This TDE is a development of Pattern I, but not the same as what was
% suggested in the Mori paper. Instead, this modification is to only use 
% three bipolar pairs and split the middle one across the 180.
% To avoid issues with concomitant gradients, the first and last bipolar
% pairs must be in the xy-plane and the middle pair must be along z.
% Ref to Szczepankiewicz et al. DOI: 10.1016/j.jneumeth.2020.109007

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 13.5e-3;
    dp = 8e-3;
    dt = 0.1e-3;
    
    [gwf, rf, dt] = fwf_gwf_create_tde(g, s, d, dp, dt);

    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end


u1 = [1 0 0];
u2 = [0 0 1];
u3 = [0 1 0];

n = round(d/dt);

trp = fwf_gwf_create_trapezoid(g, s, dt, n);
bip = [trp -trp];

wfz = zeros(1, round(dp/dt));

gwf = [
    bip'*u1;
    trp'*u2;
    wfz'*[1 1 1];
    trp'*u2;
    bip'*u3;
     ];

rf = ones(size(gwf,1),1);
mind = round(size(gwf,1)/2);
rf(mind:end) = -1;

[gwf, rf, dt] = fwf_gwf_force_shape(gwf, rf, dt, 'ste');