function [dtype, dsize] = fwf_data_type(in)
% function [dtype, dsize] = fwf_data_type(in)
%
% This function returns the data type that is stored. These values are
% hardcoded in the pulse sequence, and must be known beforehand.

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
