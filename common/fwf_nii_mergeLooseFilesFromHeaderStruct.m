function res = fwf_nii_mergeLooseFilesFromHeaderStruct(dir_in, dir_out)
% function res = fwf_nii_mergeLooseFilesFromHeaderStruct(dir_in, dir_out)
% dir_in must contain the header structure from dicm2nii converter

if nargin < 2
    dir_out = dir_in;
end

h   = load([dir_in filesep 'dcmHeaders.mat']); h = h.h;
fnl = fieldnames(h);

for i = 1:numel(fnl)
    sNum(i) = floor(h.(fnl{i}).SeriesNumber/1000);
    pNam{i} = [h.(fnl{i}).ProtocolName '_S' num2str(sNum(i), '%04d')];
end


[upNam, ~, uind] = unique(pNam);
disp(['Found ' num2str(numel(upNam)) ' unique protocols!'])


for j = 1:numel(upNam)

    clear xps hdr gwf

    ind_curr = uind==j;
    fnl_curr = fnl(ind_curr);
    nVol = numel(fnl_curr);

    disp(['Collating ' upNam{j} ' with ' num2str(nVol) ' volumes']);

    % Get metadata from first file
    try
        nii_fn_first = [dir_in filesep h.(fnl_curr{1}).NiftiName '.nii.gz'];
        [I_first, h_nii] = mdm_nii_read(nii_fn_first);
        hdr = h.(fnl_curr{1});

        ver = fwf_ver_from_siemens_hdr(hdr);

        if ~isempty(ver)
            xps = fwf_xps_from_siemens_hdr(hdr);
            xps.isOK = ones(xps.n,1);

            [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr(hdr);
            gwf.gwf = gwfc;
            gwf.rf  = rfc;
            gwf.dt  = dtc;


        else
            [b, u_nrm] = fwf_bvluvc_from_siemens_hdr(hdr);
            bt = tm_1x3_to_1x6(b, 0, u_nrm);
            xps = mdm_xps_from_bt(bt);

        end

        % Prealloc image space
        C = zeros(size(I_first,1), size(I_first,2), size(I_first,3), nVol, 'like', I_first);

        % Check if likely phase data
        if (hdr.RescaleIntercept == -4096 && hdr.RescaleSlope == 2)
            suffix = '_pha';
        else
            suffix = '_mag';
        end

        fn_nii = [dir_out filesep upNam{j} suffix '_MRG.nii.gz'];

        if exist(fn_nii, 'file')
            disp(['Skipping ' upNam{j} ' to avoid overwrite!']);
            continue
        end

        for i = 1:nVol
            nii_fn_curr = [dir_in filesep h.(fnl_curr{i}).NiftiName '.nii.gz'];
            C(:,:,:,i) = mdm_nii_read(nii_fn_curr);
        end

        fn_xps = mdm_fn_nii2xps(fn_nii);
        fn_hdr = mdm_fn_nii2hdr(fn_nii);
        fn_gwf = mdm_fn_nii2gwf(fn_nii);

        mdm_nii_write(C, fn_nii, h_nii, 0);
        mdm_xps_save(xps, fn_xps);

        res{j,1} = fn_nii;
        res{j,2} = fn_xps;

        if exist('hdr', 'var')
            save(fn_hdr, 'hdr');
            res{j,3} = fn_hdr;
        end

        if exist('gwf', 'var')
            save(fn_gwf, 'gwf');
            res{j,4} = fn_gwf;
        end

    catch me
        disp(me.message)
        continue
    end

end