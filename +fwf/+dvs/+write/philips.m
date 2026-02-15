function philips(G, outname, header)
% function philips(G, outname, header)
%
% G is an n x 4 matrix with gradient unit vectors and b-value in s/mm2.

% Check if two measurements are identical. This crashes the Philips recon
% because it is... not great.

if 1
    ur = unique(G.*(G(:,4)>0), 'rows');
    
    if size(ur,1) < size(G,1)
        error('Philips does not allow for repetition of identical measurements!')
    end
end

nub   = numel(unique(G(:,4)));
nsamp = size(G,1);
on_str = ['fsz_nos_' num2str(nsamp) '_nb_' num2str(nub)];

if nargin < 2
    outname = [on_str '.txt'];
end

if nargin < 3
    header{1} = on_str;
end


dir_cells = {};

for p=1:size(G,1)
    
    dir_cells{end+1} = [num2str(G((p),1),'%6.4f') '  ' num2str(G((p),2),'%6.4f') '  ' num2str(G((p),3),'%6.4f') '  ' num2str(G((p),4),'%6.1f')];...
        
end


%print  the header and vector
fid = fopen(outname, 'wt');

for j = 1:length(header)
    fprintf(fid,'%s\n',header{j});
end

for j = 1:length(dir_cells)
    fprintf(fid,'%s\n',dir_cells{j});
end

fclose(fid);
end













