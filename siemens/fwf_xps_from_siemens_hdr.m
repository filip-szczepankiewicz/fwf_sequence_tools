function xps = fwf_xps_from_siemens_hdr(h)
% function xps = fwf_xps_from_siemens_hdr(h)
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

csa           = fwf_csa_from_siemens_hdr(h);
seq           = fwf_seq_from_siemens_csa(csa);
[gwf, rf, dt] = fwf_gwf_from_siemens_seq(seq);
[~, nbt]      = fwf_bt_from_gwf(gwf, rf, dt);
[b, u, n]     = fwf_bvluvc_from_siemens_hdr(h);

[btl, R1x9]   = fwf_btl_from_bvluvc(b, u, n, nbt, seq.rot_mode);
xps           = mdm_xps_from_bt(btl);

xps.u         = u;
xps.rotmat    = R1x9;
xps.te        = ones(xps.n, 1) * h.EchoTime /1000;
xps.tr        = ones(xps.n, 1) * h.RepetitionTime /1000;

%% WIP
% change calculation of b to be native to csa and seq info and not rely on bval/bvec

