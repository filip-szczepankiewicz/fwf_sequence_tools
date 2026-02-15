function [gwf, rf, dt] = fwf_gwf_from_siemens_seq(seq)
% function [gwf, rf, dt] = fwf_gwf_from_siemens_seq(seq)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% Returns the waveform that was actually used on the scanner. The waveform
% is interpolated at the actual raster time, and is scaled in amplitude to
% match the maximal requested b-value. However, it is not rotated in any
% particular direction!

ver = seq.seq_ver;

if ver < 2.00
    [gwf, rf, dt] = fwf_gwf_from_siemens_seq_v1p00(seq);

else
    [gwf, rf, dt] = fwf_gwf_from_siemens_seq_v2p00(seq);

end



