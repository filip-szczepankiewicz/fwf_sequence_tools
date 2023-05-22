function [gwf, rf, dt] = fwf_gwf_create_cory90(g, s, d1, d2, dp, dt, u1, u2, dp2)
% function [gwf, rf, dt] = fwf_gwf_create_cory90(g, s, d1, d2, dp, dt, u1, u2, dp2)

if nargin < 1
    g = 0.08;
    s = 100;
    d1 = 30e-3;
    d2 = 30e-3;
    dt = 0.1e-3;
    u1 = [1 0 0];
    u2 = [0 0 1];
    dp = 8e-3;
    dp2 = 1e-3;

    [gwf, rf, dt] = fwf_gwf_create_cory90(g, s, d1, d2, dp, dt, u1, u2, dp2);

    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end

[gwf, rf, dt] = fwf_gwf_create_sedde(g, s, d1, d2, dp, dt, u1, u2, dp2);