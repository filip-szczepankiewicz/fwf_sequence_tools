function bin_fn = fwf_bin_from_sha(sha, bin_dir)
% function bin_fn = fwf_bin_from_sha(sha, bin_dir)
% By Filip Sz
%
% sha is a 1x64 character array produced by fwf_sha_from_bin_siemens at the time
% of creating the bin file.
% bin_dir is the directory where a search is performed for .bin files with
% the correct sha

if nargin < 2
    bin_dir = fwf_bin_default_directory_siemens;
end

fnl = dir([bin_dir '*.bin']);

for i = 1:numel(fnl)

    curr_fn  = [fnl(i).folder filesep fnl(i).name];
    curr_sha = fwf_sha_from_bin_siemens(curr_fn);

    if strcmp(sha, curr_sha)
        bin_fn = curr_fn;
        disp(['A .bin file with matching sha hash was found at: ' bin_fn])
        return
    end

end

error(['The .bin file was not found in library: ' bin_dir])