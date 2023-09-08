clear

order = 1;

f_name = 'Prostate_Project_v1';

dvs_fn = [f_name '.dvs'];
bin_fn = [f_name '.bin'];

[gwf{1}, rf, dt] = gwf_create_mori95_pattern3(80e-3, 100, 8.65e-3, 8e-3, 10e-6);
gwf{2} = gwf{1}(:,1)*[1 0 0];

sl = [0 1 0 .5]; % Scale list of b-vals relative to max
nl = [6 6 6  6]; % Number of rotations
il = [1 1 1  2]; % Waveform index


%% Create DVS
[dvs, wfi] = fwf_dvs_from_experiment_siemens(sl, nl, il, dvs_fn, order, bin_fn);


%% Create BIN
for i = 1:size(dvs,1)
    u   = dvs(i,:);
    R   = fwf_rm_from_siemens_uvec(u, 3);

    cwf = gwf{wfi(i)};
    nrm = max(sqrt(sum(cwf.^2,2)));
    nwf = cwf/nrm;
    swf = nwf * sqrt(sum(u.^2));
    rwf = swf * R;

    inl = bpv_gwf2partindex(cwf, rf, dt);

    GWF{1,i} = rwf(inl{1},:);
    GWF{2,i} = rwf(inl{2},:);
end

fwf_gwf2bin_siemens(GWF, bin_fn, 2)



