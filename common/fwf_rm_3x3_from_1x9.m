function rm = fwf_rm_3x3_from_1x9(rm)
% function rm = fwf_rm_3x3_from_1x9(rm)

if nargin < 1
    rm = [1 2 3; 4 5 6; 7 8 9];
    rm = fwf_rm_1x9_from_3x3(rm);
end

rm = reshape(rm, 3, 3);

