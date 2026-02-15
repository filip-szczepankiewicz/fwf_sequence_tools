function [gwf_c, rf, dt] = toConcomitant_new(gwf, rf, dt, r, B0, a, f)
% function [gwf_c, rf, dt] = fwf.gwf.toConcomitant_new(gwf, rf, dt, r, B0, a, f)

[gwf_a, rf, dt] = fwf.gwf.toActual(gwf, rf, dt, r, B0, a, f);

gwf_c = gwf_a - gwf;
