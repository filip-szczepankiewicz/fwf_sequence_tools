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

    ind_curr = uind==j;
    fnl_curr = fnl(ind_curr);
    nVol = numel(fnl_curr);

    disp(['Collating ' upNam{j} ' with ' num2str(nVol) ' volumes']);

    % Get metadata from first file
    try
        nii_fn_first = [dir_in filesep h.(fnl_curr{1}).NiftiName '.nii.gz'];
        [I_first, h_nii] = mdm_nii_read(nii_fn_first);
        hdr = h.(fnl_curr{1});
        xps = fwf_xps_from_siemens_hdr(hdr);
        xps.isOK = ones(xps.n,1);

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

        mdm_nii_write(C, fn_nii, h_nii, 0);
        mdm_xps_save(xps, fn_xps);
        save(fn_hdr, 'hdr');

        res{j,1} = fn_nii;
        res{j,2} = fn_xps;
        res{j,3} = fn_hdr;

    catch me
        disp(me.message)
        continue
    end

end