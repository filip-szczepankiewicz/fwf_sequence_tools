function xps = fwf_xps_from_bin(bin_fn, gamp, t_pause, dt, gamma)

if nargin < 5
    gamma = fwf_gamma_from_nuc('1H');
end

[btl, ver, sha] = fwf_btl_from_bin_siemens(bin_fn, gamp, t_pause, dt, gamma);

% add repetitions and stuff

xps = mdm_xps_from_bt(btl);
% xps.ver_bin = ver;
% xps.sha_bin = sha;
