function xps = xps_from_bin(bin_fn, gamp, t_pause, dt, gamma)
% function xps = fwf.silu.xps_from_bin(bin_fn, gamp, t_pause, dt, gamma)
% NOTE: This function does not include the effect of averages and multiple
% b-values, so it only coarsly depicts what is acquired by the scanner.

if nargin < 5
    gamma = fwf.util.gammaFromNuc('1H');
end

[gwfl, rfl, dtl] = fwf.silu.gwfl_from_bin(bin_fn, gamp, t_pause, dt);

xps = fwf.gwf.toXps(gwfl, rfl, dtl, gamma);