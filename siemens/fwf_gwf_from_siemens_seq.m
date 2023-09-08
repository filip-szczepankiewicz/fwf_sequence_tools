function [gwf, rf, dt, ind] = fwf_gwf_from_siemens_seq(seq)
% function [gwf, rf, dt, ind] = fwf_gwf_from_siemens_seq(seq)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
% 
% Returns the waveform that was actually used on the scanner. The waveform
% is interpolated at the actual raster time, and is scaled in amplitude to
% match the maximal requested b-value. However, it is not rotated in any
% particular direction!

ver = fwf_b64_to_version(seq.wf_stored.b64wf);

if ver>0.00 && ver<1.50
[gwf, rf, dt]      = fwf_gwf_from_siemens_seq_v1p00(seq);
    ind = [];

elseif ver>=1.50 && ver<2.00 % removeme
    [gwf, rf, dt, ind] = fwf_gwf_from_siemens_seq_v1p50(seq);

elseif ver>=2.00
    [gwf, rf, dt] = fwf_gwf_from_siemens_seq_v2p00(seq);

end



