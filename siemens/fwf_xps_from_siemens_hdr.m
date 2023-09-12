function xps = fwf_xps_from_siemens_hdr(hdr)
% function xps = fwf_xps_from_siemens_hdr(hdr)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% Create experimental parameter structure (XPS) compatible with the
% multidimensional diffusion toolbox (REQUIRED to execute function):
% https://github.com/markus-nilsson/md-dmri (mdm_xps_from_bt)
%
% h is series dicom header, for example extracted with xiangruili/dicm2nii (dicm_hdr)
% https://github.com/xiangruili/dicm2nii

% This function depends a lot on the pulse sequence version

[gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr(hdr);
gamma            = fwf_gamma_from_nuc(fwf_nuc_from_siemens_hdr(hdr));

btl              = fwf_gwfc_to_btens(gwfc, rfc, dtc, gamma);
xps              = mdm_xps_from_bt(btl);

xps.te           = ones(xps.n, 1) * hdr.EchoTime /1000;
xps.tr           = ones(xps.n, 1) * hdr.RepetitionTime /1000;

