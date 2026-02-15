clear

order = 0;

f_name = 'FWF_dti_lte_v1.0';

dvs_fn = [f_name '.dvs'];
bin_fn = [f_name '.bin'];

[stea, steb, ltea, lteb, ptea, pteb] = hc_wf_v2();

dt  = 0.7e-3;
tz  = 8e-3;
nz  = ceil(8e-3/dt);
gwf = [ltea; zeros(nz,3); lteb];
rf  = ones(size(gwf,1),1);
rf((size(ptea,1)+round(nz)):end) = -1;

n = round((size(gwf,1)-1)*dt/10e-6);

[tmp, rf, dt] = fwf_gwf_interp(gwf, rf, dt, n);

clear gwf
gwf{1} = tmp;

bl = [0 1 ]; % b-vals
nl = [1 12]; % Number of rotations
il = [1 1 ]; % Waveform index


%% Create DVS
[dvs, wfi] = fwf_dvs_from_experiment_siemens(bl, nl, il, dvs_fn, order, bin_fn);
bvl        = max(bl) * sum(dvs.^2, 2);


%% Create BIN
for i = 1:size(dvs,1)
    u   = dvs(i,:);
    R   = fwf_rm_from_siemens_uvec(u, 3);

    cwf = gwf{wfi(i)};
    cb  = gwf_to_bval(cwf, rf, dt);
    swf = cwf * sqrt(bvl(i)/cb);
    rwf = swf * R;

    inl = fwf_gwf_to_partindex(cwf, rf, dt);

    GWF{1,i} = rwf(inl{1},:);
    GWF{2,i} = rwf(inl{2},:);
end

fwf_gwf2bin_siemens(GWF, bin_fn, 1)


%% CHECK
gamp = 70e-3; % T/m
tp   = 8e-3;  % s
dt   = 10e-6; % s
breq = 1.0e9; % s/m2

tmp = fwf_xps_from_bin(bin_fn, gamp, tp, dt);

gamp_new = gamp*sqrt(breq/max(tmp.b));

xps = fwf_xps_from_bin(bin_fn, gamp_new, tp, dt);

mdm_xps_info   (xps)

clf
hist(xps.b/1e6, 100)
title(['b-vals at ' num2str(gamp_new*1000,3) ' mT/m'])

