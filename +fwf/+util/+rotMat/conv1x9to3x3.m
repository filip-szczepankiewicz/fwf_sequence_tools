function rm = conv1x9to3x3(rm)
% function rm = fwf.util.rotMat.conv1x9to3x3(rm)

if nargin < 1
    rm = [1 2 3; 4 5 6; 7 8 9];
    rm = fwf.util.rotMat.conv3x3to1x9(rm);
end

rm = reshape(rm, 3, 3);

