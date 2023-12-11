function [gwf, rf, dt, ind] = fwf_gwf_from_siemens_hdr(h)
% function [gwf, rf, dt, ind] = fwf_gwf_from_siemens_hdr(h)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
% 
% h is series dicom header extracted with xiangruili/dicm2nii
% https://se.mathworks.com/matlabcentral/fileexchange/42997-xiangruili-dicm2nii
%
% Dicom header must be modified according to the conventions of the 
% Free Waveform Encoding (FWF) sequence, and only works for FWF sequence
% versions 1.12 and later.

csa           = fwf_csa_from_siemens_hdr(h);
seq           = fwf_seq_from_siemens_csa(csa);
[gwf, rf, dt] = fwf_gwf_from_siemens_seq(seq);
