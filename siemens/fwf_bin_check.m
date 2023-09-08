clear

bin_fn = 'Prostate_Project_v1.bin';

gamp = 80e-3; % T/m
tp   = 8e-3;  % s
dt   = 10e-6; % s

xps = fwf_xps_from_bin(bin_fn, gamp, tp, dt);

mdm_xps_info(xps)
