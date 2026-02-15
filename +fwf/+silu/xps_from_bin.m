function xps = fwf_xps_from_bin(bin_fn, gamp, t_pause, dt, gamma)
% function xps = fwf_xps_from_bin(bin_fn, gamp, t_pause, dt, gamma)
% NOTE: This function does not include the effect of averages and multiple
% b-values, so it only coarsly depicts what is acquired by the scanner.

if nargin < 5
    gamma = fwf_gamma_from_nuc('1H');
end

[gwfl, rfl, dtl] = fwf_gwfl_from_bin_siemens(bin_fn, gamp, t_pause, dt);

xps = fwf_xps_from_gwfl(gwfl, rfl, dtl, gamma);