function fn_cplx = nii2complex_siemens(fn_mag, fn_pha, fn_cplx, fn_xps)
% function fn_cplx = fwf.util.nii2complex_siemens(fn_mag, fn_pha, fn_cplx, fn_xps)

if nargin < 3
    fn_cplx = mdm_fn_nii2complex(fn_mag);
end

if nargin < 4
    fn_xps = mdm_fn_nii2xps(fn_mag);
end

% Read pair of nii files
[Imag, h] = mdm_nii_read(fn_mag);
Ipha      = mdm_nii_read(fn_pha);

% Convert to single float
Imag = single(Imag);
Ipha = single(Ipha);

% Special Siemens transform
Ipha  = single(Ipha/(2^12-1)*pi());
Icplx = Imag .* exp( 1i * Ipha);

% Save output
fn_cplx = mdm_nii_write(Icplx, fn_cplx, h, 0);

% Attempt to copy corresponding xps file
try
xps  = mdm_xps_load(fn_xps);
mdm_xps_save(xps, mdm_fn_nii2xps(fn_cplx));
catch
    disp('Failed to copy xps!')
end