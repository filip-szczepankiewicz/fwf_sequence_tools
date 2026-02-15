function [R, v] = dcm2xyz(dicom_fn)
% function [R, v] = fwf.util.dcm2xyz(dicom_fn)
% By FSz
%
% Input can be file path to dicom file, or a dicom header structure 
% created by dicm2nii.

try
    h = dicm_hdr(dicom_fn);
catch
    %assume that input is heder
    h = dicom_fn;
end

% Get the top left corner position (TLC) and the row/collumn unit vectors
v_tlc = h.ImagePositionPatient;
v_row = [h.ImageOrientationPatient(1); h.ImageOrientationPatient(2); h.ImageOrientationPatient(3)];
v_col = [h.ImageOrientationPatient(4); h.ImageOrientationPatient(5); h.ImageOrientationPatient(6)];

% Calculate the slice direction
v_slice = cross(v_row, v_col);

% Get the number of rows/collumns and the voxel spacing
nr    = double(h.Rows);
nc    = double(h.Columns);
sr    = h.PixelSpacing(1);
sc    = h.PixelSpacing(1);

% Create a image raster. Origin is in [0, 0].
r_row = repmat((1:nr)' -1, 1, nc);
r_col = repmat((1:nc)  -1, nr, 1);

% Return the x, y, z coordinates
R = zeros([size(r_row) 3]);

for i = 1:3
    R(:,:,i) = v_tlc(i) + sr * v_row(i) * r_row  +  sc * v_col(i) * r_col;
end

R = R/1000; % mm -> m

switch h.ImageOrientation
    case 'Cor'
        Z =  R(:,:,1);
        Y = -R(:,:,2);
        X = R(:,:,3);
        
    case 'Sag'
        X =  R(:,:,1);
        Y =  R(:,:,3);
        Z =  R(:,:,2);
        
    case 'Tra'
%         X =  R(:,:,2);
%         Y = -R(:,:,1);
%         Z = -R(:,:,3);
%         Y = Y - 30e-3;
        
        X =  R(:,:,1);
        Y =  R(:,:,2);
        Z =  R(:,:,3);
%         Y = Y - 30e-3;
        
    otherwise % Tra and oblique
        X =  R(:,:,2);
        Y = -R(:,:,1);
        Z = -R(:,:,3);
        Y = Y - 30e-3;
        warning('This code is likely wrong!!!')
end


switch h.InPlanePhaseEncodingDirection
    case 'COL'
        v_phase = v_col;
    case 'ROW'
        v_phase = v_row;
    otherwise
        error('not known')
end


% Package
clear R

R.x = X;
R.y = Y;
R.z = Z;

v.col = v_col;
v.row = v_row;
v.sli = v_slice;
v.pha = v_phase;

