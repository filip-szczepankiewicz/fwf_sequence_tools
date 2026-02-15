function gps = gps_from_hdr(h)
% function gps = fwf.silu.gps_from_hdr(h)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% h is series dicom header, for example extracted with xiangruili/dicm2nii (dicm_hdr)
% https://github.com/xiangruili/dicm2nii

[gwfc, rfc, dtc] = fwf.silu.gwf_list_from_hdr(h);

gps.gwf = gwfc;
gps.rf  = rfc;
gps.dt  = dtc;