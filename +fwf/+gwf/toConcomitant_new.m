function [gwf_c, rf, dt] = fwf_gwf_to_gwf_concomitant(gwf, rf, dt, r, B0, a, f)
% function [gwf_c, rf, dt] = fwf_gwf_to_gwf_concomitant(gwf, rf, dt, r, B0, a, f)

[gwf_a, rf, dt] = fwf_gwf_to_gwf_actual(gwf, rf, dt, r, B0, a, f);

gwf_c = gwf_a - gwf;
