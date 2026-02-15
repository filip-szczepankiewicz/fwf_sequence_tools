function [dvs, dvs_fn] = fwf_dvs_write_siemens(dvs, dvs_fn, hdr_opt)
% function [dvs, dvs_fn] = fwf_dvs_write_siemens(dvs, dvs_fn, hdr_opt)
% By Filip Szczepankiewicz, Lund University
%
% dvs is nX3 or nx4 matrix with gradient vectors and an optional collumn
% for waveform index (adapted to the multi-waveform update).

numRow = size(dvs,1);
numCol = size(dvs,2);
vec    = dvs(:,1:3);
nrm    = sqrt(sum(vec.^2, 2));
maxNrm = max(nrm);
uniNrm = uniquetol(nrm, 0.01);

if nargin < 2
    dvs_fn = 'CustomDirectionTable.dvs';
end

if nargin < 3
    hdr_opt = {
        ['# ---------- DIFFUSION VECTOR SET ----------']
        ['# by Filip Szczepankiewicz, ' date]
        ['# https://github.com/filip-szczepankiewicz/fwf_seq_resources']
        ['# Total number of samples = ' num2str(numRow)]
        ['# Maximal norm = ' num2str(maxNrm, '%0.2f')]
        ['# B-value scales = ' num2str(uniNrm.^2', '%0.2f ')]
        };

    if numCol > 3
        uwf = unique(dvs(:,4));
        nuw = numel(uwf);

        hdr_opt = [hdr_opt; {
            ''
            ['# DVS file is compatible with the Multi-FWF update!']
            ['# Number or unique waveform indices = ' num2str(nuw)];
            ['# Unique indices are = ' num2str(uwf', '%i ')]
            ''
            }];
    end
end


% Standard Siemens header
hdr_std = {[
    '[directions=' num2str(size(dvs,1)) ']']
    'Normalization = None'
    'Coordinatesystem = xyz'
    };

% Special FWF header
if numCol > 3
    hdr_std = [hdr_std; {'fwfMode = 1'; ''}];
end

hdr = [hdr_opt; hdr_std];



startline = length(hdr)+2;
c = 1;
for p = startline:(size(dvs,1)+startline-1)

    switch numCol
        case 3
            hdr{p} = ['vector[' num2str(c-1) ']=(' num2str(dvs(c,1),'%6.4f') ',' num2str(dvs(c,2),'%6.4f') ',' num2str(dvs(c,3),'%6.4f') ')'];

        case 4
            hdr{p} = ['vector[' num2str(c-1) ']=(' num2str(dvs(c,1),'%6.4f') ',' num2str(dvs(c,2),'%6.4f') ',' num2str(dvs(c,3),'%6.4f') ',' num2str(dvs(c,4),'%i') ')'];

        otherwise
            error('Format of DVS is not recognized!')
    end

    c = c+1;

end


% print the header and dvs to file
fid = fopen(dvs_fn, 'wt');

for j = 1:length(hdr)
    fprintf(fid,'%s\n',hdr{j});
end

fclose(fid);
end













