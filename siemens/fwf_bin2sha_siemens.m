function sha = fwf_bin2sha_siemens(bin_fn)
% function sha = fwf_bin2sha_siemens(bin_fn)

% FIXME: just read the sha, skipping the GWF
[~, ~, sha] = fwf_bin2gwf_siemens(bin_fn);