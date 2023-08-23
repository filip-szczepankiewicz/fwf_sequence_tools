function [bin_fn, status] = fwf_gwf2bin_siemens(GWF, bin_fn, norm)
% function [bin_fn, status] = fwf_gwf2bin_siemens(GWF, bin_fn, norm)
% By Arthur Chakwizira and Filip Sz
%
% GWF is a cell array with size 2xn where n is the number of unique
% waveforms (n_gwf).
% int32 is used to define binary size to type "long"

if nargin < 3
    norm = 1;
end

n_U = int32(size(GWF, 2));
n_A = int32(size(GWF{1,1},1));
n_B = int32(size(GWF{2,1},1));

g_A = [];
g_B = [];


for c = 1:n_U
    g_A = [g_A; GWF{1,c}];
    g_B = [g_B; GWF{2,c}];
end


switch norm
    case 1 %L2
        f_norm = max(sqrt(sum([g_A;g_B].^2, 2)));
    case 2 %Max
        f_norm = max(abs([g_A(:); g_B(:)]));
    otherwise
        error('Norm not supported')
end

gn_A = single(g_A/f_norm);
gn_B = single(g_B/f_norm);

% sha = fwf_gwf2sha([gn_A; gnB]);

% WRITE TO BINARY
fileID = fopen(bin_fn, 'w');

% fwrite(fileID, sha, 'undecided');

fwrite(fileID, n_U, 'int32');
fwrite(fileID, n_A, 'int32');
fwrite(fileID, n_B, 'int32');

fwrite(fileID, gn_A(:,1), 'single');
fwrite(fileID, gn_A(:,2), 'single');
fwrite(fileID, gn_A(:,3), 'single');
fwrite(fileID, gn_B(:,1), 'single');
fwrite(fileID, gn_B(:,2), 'single');
fwrite(fileID, gn_B(:,3), 'single');

status = fclose(fileID);

