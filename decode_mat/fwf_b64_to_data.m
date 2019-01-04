function res = fwf_b64_to_data(b64arr)
% function res = fwf_b64_to_data(b64arr)
%
% By Filip Szczepankiewicz and Isaiah Norton
% Function translates a specific encoding of the waveform from a base-64
% character array into numeric data.

if strcmp(b64arr, 'EMPTY')
    res = [];
    return
end

uint8arr    = matlab.net.base64decode(b64arr);

% GET MAIN HEADER INFO
res.name    = char(uint8arr(1:4));
res.version = char(uint8arr(5:8));
res.blocks  = typecast(uint8arr(9:12), 'int32');

uint8arr(1:12) = [];

if ~strcmp(res.name, 'MDMR')
    error('Input string format is not recognized');
end

switch res.version
    
    case {'0001', '1.12', '1.13'}
        
        % GET BLOCK INFO
        for i = 1:res.blocks
            [dtype, dsize] = fwf_data_type(uint8arr(1:4));
            bsize          = typecast(uint8arr(5:12), 'int64');
            res.dtype{i}   = dtype; % Data type
            res.dsize(i)   = dsize; % Data size (in bytes = 8 bit)
            res.bsize(i)   = bsize; % Block size (length of wf)
            uint8arr(1:12) = [];
        end
        
        % GET BLOCK DATA
        for i = 1:res.blocks
            block_end   = res.bsize(i) * res.dsize(i);
            res.data{i} = typecast(uint8arr(1:block_end), res.dtype{i});
            uint8arr(1:block_end) = [];
        end
        
        
    otherwise
        error(['Version ' res.version 'is not recognized!']);
        
end
