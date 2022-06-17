# Siemens impementation for Lund University FWF sequence
This header extraction is mainly based on the information stored in a Siemens private DICOM tag called CSASeriesHeaderInfo and MrPhoenixProtocol. The additional data is stored in a container called 'tFree' of the 'WIPMemBlock.' The header extraction is compatible with FWF sequence versions 1.13 and later. Please refer to the version list [here](https://github.com/filip-szczepankiewicz/fwf_seq_resources/tree/master/Siemens). From version 1.50 there is also support for using multiple waveforms in a single sequence (exam card).

The header information can be extracted by converting the DICOM files to NIFTI using [dicm2nii by Xiangrui Li](https://github.com/xiangruili/dicm2nii). Doing so creates a header structure in MATLAB format. Although headers can be extracted directly from the DICOM file, the code in this repository is adapted to be compatible with the .mat header file produced by dicm2nii.

### Warning
It is currently unknown if the storage container (tFree) should be limited to 128 characters, or if it is 'unlimited.' Although this encoding has been used to store thousands of characters in tFree without detected errors on several platforms, it may break convention and cause errors! Please use caution!

### Example 1
```
% Load header structure 'h' into workspace
load('path_to_dicm2nii_output_folder\dcmHeaders.mat')

% Get gradient waveform and supplementary info
[gwf, rf, dt] = fwf_gwf_from_siemens_hdr(h.my_seq_name);

% Get sequence timing and imaging parameters
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
