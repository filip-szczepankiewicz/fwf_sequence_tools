function bin_fn = bin_from_sha(sha, bin_dir)
% function bin_fn = fwf.lusi.bin_from_sha(sha, bin_dir)
% By Filip Sz
%
% sha is a 1x64 character array produced by fwf.lusi.sha_from_bin at the time
% of creating the bin file.
% bin_dir is the directory where a search is performed for .bin files with
% the correct sha

if nargin < 2
    bin_dir = fwf.lusi.bin_default_directory;
end

fnl = dir([bin_dir '*.bin']);

for i = 1:numel(fnl)

    curr_fn  = [fnl(i).folder filesep fnl(i).name];
    curr_sha = fwf.lusi.sha_from_bin(curr_fn);

    if strcmp(sha, curr_sha)
        bin_fn = curr_fn;
        disp(['A .bin file with matching sha hash was found at: ' bin_fn])
        return
    end

end

error(['The .bin file was not found in library: ' bin_dir])