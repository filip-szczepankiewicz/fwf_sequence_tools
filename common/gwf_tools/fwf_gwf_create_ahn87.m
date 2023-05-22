function [gwf, rf, dt] = fwf_gwf_create_ahn87(g, s, d1, d2, dp, dt, u, dp2)
% function [gwf, rf, dt] = fwf_gwf_create_ahn87(g, s, d1, d2, dp, dt, u, dp2)
% 
% See reference
% Ahn et al. Med. Phys. 1987

if nargin < 1
    g = 0.08;
    s = 100;
    d1 = 30e-3;
    d2 = 30e-3;
    dt = 4e-5;
    u = [1 0 0];
    dp = 8e-3;
    dp2 = 1e-3;

    [gwf, rf, dt] = fwf_gwf_create_ahn87(g, s, d1, d2, dp, dt, u, dp2);

    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end

[gwf, rf, dt] = fwf_gwf_create_sedde(g, s, d1, d2, dp, dt, u, u, dp2);