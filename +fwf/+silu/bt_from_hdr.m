function [bt_3x3, bt_1x6] = bt_from_hdr(h)
% function [bt_3x3, bt_1x6] = fwf.silu.bt_from_hdr(h)


if h.PerFrameFunctionalGroupsSequence.Item_1.MRDiffusionSequence.Item_1.B_value == 0
    Bxx = 0;
    Byy = 0;
    Bzz = 0;
    Bxy = 0;
    Bxz = 0;
    Byz = 0;
else
    Bxx = h.PerFrameFunctionalGroupsSequence.Item_1.MRDiffusionSequence.Item_1.DiffusionB_MatrixSequence.Item_1.DiffusionB_ValueXX;
    Byy = h.PerFrameFunctionalGroupsSequence.Item_1.MRDiffusionSequence.Item_1.DiffusionB_MatrixSequence.Item_1.DiffusionB_ValueYY;
    Bzz = h.PerFrameFunctionalGroupsSequence.Item_1.MRDiffusionSequence.Item_1.DiffusionB_MatrixSequence.Item_1.DiffusionB_ValueZZ;
    Bxy = h.PerFrameFunctionalGroupsSequence.Item_1.MRDiffusionSequence.Item_1.DiffusionB_MatrixSequence.Item_1.DiffusionB_ValueXY;
    Bxz = h.PerFrameFunctionalGroupsSequence.Item_1.MRDiffusionSequence.Item_1.DiffusionB_MatrixSequence.Item_1.DiffusionB_ValueXZ;
    Byz = h.PerFrameFunctionalGroupsSequence.Item_1.MRDiffusionSequence.Item_1.DiffusionB_MatrixSequence.Item_1.DiffusionB_ValueYZ;
end

% B-tensor in unscaled SI units (s/m^2)
bt_3x3 = [
    Bxx Bxy Bxz
    Bxy Byy Byz
    Bxz Byz Bzz
    ] * 10e6;

% Here we store the B-tensor in a single row using something similar to Voight
% notation. This is adapted to the mddMRI framework
% (https://github.com/markus-nilsson/md-dmri), where the same format is
% used in tm_3x3_to_1x6.
bt_1x6 = bt_3x3([1 5 9 2 3 6]) .* [1 1 1 sqrt(2) * [1 1 1]];