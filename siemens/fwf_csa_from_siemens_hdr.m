function csa = fwf_csa_from_siemens_hdr(h)
% function csa = fwf_csa_from_siemens_hdr(h)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
% 
% Based on the dicom header reader at https://github.com/xiangruili/dicm2nii

csa = h.CSASeriesHeaderInfo.MrPhoenixProtocol;
