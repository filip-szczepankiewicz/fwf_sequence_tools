function fwf_dicm2nii_batch(main_dir, do_overwrite)
% function fwf_dicm2nii_batch(main_dir, do_overwrite)

if nargin < 2
    do_overwrite = 0;
end

pl = dir(main_dir);

for i = 1:numel(pl)

    % Source folder
    sf = [pl(i).folder filesep pl(i).name filesep];

    % Target folder
    tf = [sf '/../NII' filesep];

    % SKIP IF
    if strcmp(pl(i).name(1), '.')
        continue
    end

    if ~pl(i).isdir
        continue
    end

    if strcmp(pl(i).name(1), '_')
        continue
    end

    if exist(tf, 'dir') && ~do_overwrite
        continue
    end

    % ELSE CONVERT
    disp(['Converting folder ' num2str(i) ': ' sf])

    try
        dicm2nii(sf, tf, 1)
    catch me
        disp(me.message)
        disp(me.stack)
    end

    hdf_fn = [tf filesep 'dcmHeaders.mat'];

    try
        fwf_xps_from_dicm2nii_h_struct(hdf_fn, 1)
    catch
    end

end