function res = parse_b64_waveform(b64arr)
% function res = parse_b64_waveform(b64arr)
% By Filip Szczepankiewicz and Isaiah Norton
% Function translates a specific encoding of the waveform from base 64 in
% terms of a character array, into a header and numerical waveform values.
% The code used to encode the waveform is found here (GIT repo):
% https://github.com/ihnorton/mdmr_vec_block/

if nargin == 0
    % Example array used for testing
    b64arr = 'TURNUjAwMDEGAAAAAwAAAAcAAAAAAAAAAwAAAAcAAAAAAAAAAwAAAAcAAAAAAAAAAwAAAAkAAAAAAAAAAwAAAAkAAAAAAAAAAwAAAAkAAAAAAAAAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgD8AAAAAAAAAAAAAgL8AAAAAAAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAMzMzPwAAAAAAAAAAAAAAPwAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNzMw9AAAAAAAAAD8AAAAA';
end

uint8arr    = matlab.net.base64decode(b64arr);


% GET MAIN HEADER
res.name    = char(uint8arr(1:4));
res.version = char(uint8arr(5:8));
res.blocks  = typecast(uint8arr(9:12), 'int32');

uint8arr(1:12) = [];


if ~strcmp(res.name, 'MDMR')
    error('Input string format is not recognized');
end


switch res.version
    case '0001'
        
        % GET BLOCK INFO
        for i = 1:res.blocks
            [dtype, dsize] = get_data_type(uint8arr(1:4));
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
        
        % CREATE STANDARD FORMAT GRADIENT WAVEFORM
        res = compile_gwf_from_blocks(res); % Compiles res.gwf
        
    otherwise
        error('Version is not recognized!');
end

if 0
    plot(res.gwf); hold on
    plot(res.rf, 'o')
end

end


function [dtype, dsize] = get_data_type(in)
% This function returns the data type that is stored. These values are
% hardcoded in the pulse sequence, and ust be known beforehand.

type_num = typecast(in, 'uint32');

switch type_num
    case 0 % char_t
        dtype = 'char';
        dsize = 1;
    case 1 % int32
        dtype = 'int32';
        dsize = 4;
    case 2 % int64
        dtype = 'int64';
        dsize = 8;
    case 3 % float32
        dtype = 'single';
        dsize = 4;
    case 4 % float64
        dtype = 'double';
        dsize = 8;
    otherwise
        error('Data format not recognized!')
end

end


function res = compile_gwf_from_blocks(res)
% Compile the gwf in a standard format. Note that the pause time is
% replaced by NaN values, and must be completed from other sequence
% parameters.

for i = 1:6
    if i <= 3
        gwf1(:,i) = res.data{i};
    else
        gwf2(:,i-3) = res.data{i};
    end
end

res.gwf = [gwf1; nan(1,3); gwf2];
res.rf  = [ones(size(gwf1,1), 1); 0; -ones(size(gwf2,1), 1)];
end
