function seq = fwf_seq_from_siemens_header(h)
% function xps = fwf_seq_from_siemens_header(h)
%
% h is series dicom header extracted with xiangruili/dicm2nii
% https://se.mathworks.com/matlabcentral/fileexchange/42997-xiangruili-dicm2nii

csa           = fwf_csa_from_siemens_header(h);
seq           = fwf_seq_from_siemens_csa(csa);