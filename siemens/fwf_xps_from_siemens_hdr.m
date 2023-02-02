function xps = fwf_xps_from_siemens_hdr(hdr)
% function xps = fwf_xps_from_siemens_hdr(hdr)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% Create experimental parameter structure (XPS) compatible with the
% multidimensional diffusion toolbox (REQUIRED to execute function):
% https://github.com/markus-nilsson/md-dmri
%
% h is series dicom header, for example extracted with xiangruili/dicm2nii (dicm_hdr)
% https://github.com/xiangruili/dicm2nii

[gwfc, rfc, dtc, ind] = fwf_gwf_list_from_siemens_hdr(hdr);

nuc                   = fwf_nuc_from_siemens_hdr(hdr);

for i = 1:numel(gwfc)
    bt3x3    = fwf_bt_from_gwf(gwfc{i}, rfc{i}, dtc{i}, fwf_gamma_from_nuc(nuc));
    btl(i,:) = tm_3x3_to_1x6(bt3x3);
end

xps           = mdm_xps_from_bt(btl);
xps.te        = ones(xps.n, 1) * hdr.EchoTime /1000;
xps.tr        = ones(xps.n, 1) * hdr.RepetitionTime /1000;
xps.wf_ind    = ind;

%% WIP
% change calculation of b to be native to csa and seq info and not rely on bval/bvec

