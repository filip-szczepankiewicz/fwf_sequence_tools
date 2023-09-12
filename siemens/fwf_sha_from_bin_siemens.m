function [sha, ver] = fwf_sha_from_bin_siemens(bin_fn)
% function [sha, ver] = fwf_sha_from_bin_siemens(bin_fn)

fileID  = fopen(bin_fn, 'r');
ver     = fread(fileID, 1, 'single');

%% VERSION 1.0
sha_ui8 = fread(fileID, 64, 'uint8');
fclose(fileID);

sha     = cast(sha_ui8, 'char')';