function R3x3 = fwf_rm_1x9to3x3(R1x9)
% function R3x3 = fwf_rm_1x9to3x3(R1x9)

if nargin < 1
    R = [1 2 3; 4 5 6; 7 8 9];
    R1x9 = R(:)';
end

R3x3 = reshape(R1x9, 3, 3);

