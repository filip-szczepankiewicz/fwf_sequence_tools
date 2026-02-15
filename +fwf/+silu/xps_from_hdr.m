function xps = xps_from_hdr(hdr)
% function xps = fwf.silu.xps_from_hdr(hdr)
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
[gwfc, rfc, ...
    dtc, tStart] = fwf.silu.gwf_list_from_hdr(hdr);

xps              = fwf.gwf.toXps(gwfc, rfc, dtc, [], tStart);

[~, ~, ~, dvs]   = fwf.silu.bvluvc_from_hdr(hdr);

xps.dvs          = dvs; 
xps.te           = ones(xps.n, 1) * hdr.EchoTime /1000;
xps.tr           = ones(xps.n, 1) * hdr.RepetitionTime /1000;

%% WIP
% change calculation of b to be native to csa and seq info and not rely on bval/bvec
