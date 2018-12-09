clear
clf

% This series dicom header extracted with xiangruili/dicm2nii
% https://se.mathworks.com/matlabcentral/fileexchange/42997-xiangruili-dicm2nii
load('example_dicm2nii_header.mat');

% We can extract the gradient waveform that was used in the sequence. Note
% that this is ony one of the scales and rotations.
[gwf, rd, dt] = fwf_gwf_from_siemens_header(h);

% To extract the waveform for each image volume in the series, we must
% reconstruct the scaling and rotation of the gradient waveform. THe
% following function calculated the experimental paramter structure (XPS)
% according to the format used in the multidimensional diffusion toolbox.
% Note that this toolbox is needed to execute the xps calculation.
% https://github.com/markus-nilsson/md-dmri
xps = fwf_xps_from_siemens_header(h);