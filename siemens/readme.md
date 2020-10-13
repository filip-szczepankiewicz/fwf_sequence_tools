# Siemens impementation for Lund University FWF sequence
This header extraction is mainly based on the information stored in a Siemens private DICOM tag called CSASeriesHeaderInfo and MrPhoenixProtocol. The header extraction is compatible with FWF sequence versions 1.13 and on. Please refer to the version list [here](https://github.com/filip-szczepankiewicz/fwf_seq_resources/tree/master/Siemens).

The header information can be extracted by converting the DICOM files to NIFTI using [dicm2nii by Xiangrui Li](https://github.com/xiangruili/dicm2nii). Doing so creates a header structure in MATLAB format. Although headers can be extracted directly from the DICOM file, the code in this repository is adapted to be compatible with the dicm2nii .mat header file.

### Example 1
```
% Load header structure 'h' into workspace
load('path_to_dicm2nii_output_folder\dcmHeaders.mat')

% Get gradient waveform and supplementary info
[gwf, rf, dt] = fwf_gwf_from_siemens_hdr(h.my_seq_name);

% Get sequence timting and imaging parameters
seq = fwf_seq_from_siemens_hdr(h.my_seq_name);

% Get experimental parameter structure (xps) compatible with the multidim MRI framework
xps = fwf_xps_from_siemens_hdr(h.my_seq_name);

```

### Example 2
```
% Load header structure 'h' into workspace
load('path_to_dicm2nii_output_folder\dcmHeaders.mat')

% Create an xps files for each sequence in the converted folder (by dicm2nii)
xps_l = fwf_xps_from_dicm2nii_h_struct(h, 'path_to_my_output_folder')

```
