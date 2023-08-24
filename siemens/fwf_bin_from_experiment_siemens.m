clear

order = 0;

dvs_fn = 'tester.dvs';
bin_fn = 'fasfas';

[gwf{1}, rf, dt] = load_gwf_from_lib(11);
gwf{2} = gwf{1}(:,1)*[1 0 0];

bl = [0 1 0 .5];
nl = [6 6 6  6];
il = [1 1 1  2];

[dvs, wfi] = fwf_dvs_from_experiment_siemens(bl, nl, il, dvs_fn, order, bin_fn);

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