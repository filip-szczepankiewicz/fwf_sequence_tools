function GWF_read = fwf_bin2gwf_siemens(bin_fn)
% function GWF_read = fwf_bin2gwf_siemens(bin_fn)
% By Filip Sz

fileID = fopen(bin_fn, 'r');

n_U = fread(fileID, 1, 'int32');
n_A = fread(fileID, 1, 'int32');
n_B = fread(fileID, 1, 'int32');

gn_A(:,1) = fread(fileID, n_A*n_U, 'single');
gn_A(:,2) = fread(fileID, n_A*n_U, 'single');
gn_A(:,3) = fread(fileID, n_A*n_U, 'single');
gn_B(:,1) = fread(fileID, n_B*n_U, 'single');
gn_B(:,2) = fread(fileID, n_B*n_U, 'single');
gn_B(:,3) = fread(fileID, n_B*n_U, 'single');

fclose(fileID);

GWF_read = cell(2, n_U);
for c = 1:n_U
    GWF_read{1,c} = gn_A(  ((c-1)*n_A+1):(c*n_A), :  );
    GWF_read{2,c} = gn_B(  ((c-1)*n_B+1):(c*n_B), :  );
end
