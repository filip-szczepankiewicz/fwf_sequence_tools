function [gwf, rfwf, t] = fwf_read_seqDiagram_siemens(fn_diag)
% function [gwf, rfwf, t] = fwf_read_seqDiagram_siemens(fn_diag)
%
% fn_diag is file name of siemens pulse sequence diagram file (.txt)
% gwf is the gradient waveform
% rfwf is the radio frequency waveform
% t is the time

fid = fopen(fn_diag,'r');
if fid == -1
    error('Cannot open file: %s', filename);
end

lines = textscan(fid,'%s','Delimiter','\n');
fclose(fid);
lines = lines{1};

% Extract time step/GRT from header (look for 'time step')
tsLine = lines(contains(lines,'Time Step'));
if isempty(tsLine)
    error('No Time Step info found in file header.');
end

tokens = regexp(tsLine{1},'Time Step\s*=\s*([\d\.]+)','tokens');
timeStep_us = str2double(tokens{1}{1}); % time step in microseconds

fprintf('Time step = %.3f microseconds\n', timeStep_us);

% Remove comments
dataLines = lines(~startsWith(strtrim(lines), ';'));

% Convert content to to numeric
data = cellfun(@(x) str2num(x), dataLines, 'UniformOutput', false);
data = vertcat(data{:});  % numeric matrix, size = [N x M]

gwf  = data(:,1:3)*1e-3; % gradient waveform in T/m
rfwf = data(:, 4:end);   % RF waveform in some scale of T (µT?)

% Construct time axis
nSamples = size(data,1);
t = (0:nSamples-1).' * timeStep_us * 10-6;  % time vector in seconds
