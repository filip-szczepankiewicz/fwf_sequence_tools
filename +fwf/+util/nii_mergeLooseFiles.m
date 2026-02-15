function fn_nii = nii_mergeLooseFiles(main_dir, prfx_mag, prfx_pha, dir_out, fn_out, hdr_str)
% function fn_nii = fwf.util.nii_mergeLooseFiles(main_dir, prfx_mag, prfx_pha, dir_out, fn_out, hdr_str)

fnl_mag = find_files_under_folder([main_dir filesep prfx_mag '*.nii.gz'], 0, 'detail');
fn_hdr  = find_files_under_folder([main_dir filesep 'dcmHeaders.mat'], 1, 'detail');

if isempty(prfx_pha)
    do_complex = 0;
else
    do_complex = 1;
    fnl_pha = find_files_under_folder([main_dir filesep prfx_pha '*.nii.gz'], 0, 'detail');
end


nVol = numel(fnl_mag);


for i = 1:nVol
    M = mdm_nii_read(fnl_mag{i});

    if i == 1
        h = mdm_nii_read_header(fnl_mag{i});
        C = zeros(size(M,1), size(M,2), size(M,3), nVol, 'like', single(1j));
        hdr = load(fn_hdr{1});
        hdr = hdr.h.(hdr_str);
        xps = fwf.silu.xps_from_hdr(hdr);
        xps.isOK = ones(xps.n,1);
    end

    C(:,:,:,i) = single(M);
end


if do_complex
    for i = 1:nVol
        P = mdm_nii_read(fnl_pha{i});
        P = single(P/(2^12-1)*pi());

        try
            C(:,:,:,i) = C(:,:,:,i) .* exp( 1i * P);

        catch
            disp(['Volume ' num2str(i) ' failed to combine with phase!'])
            xps.isOK(i) = 0;
        end
    end
else
    C = abs(C);
end

fn_nii = mdm_nii_write(C, [dir_out filesep fn_out], h, 0);
mdm_xps_save(xps, mdm_fn_nii2xps(fn_nii));
save(mdm_fn_nii2hdr(fn_nii), 'hdr');