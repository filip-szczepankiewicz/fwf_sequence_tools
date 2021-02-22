function csa = fwf_csa_from_siemens_hdr(h)
% function csa = fwf_csa_from_siemens_hdr(h)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden

try
    csa = h.CSASeriesHeaderInfo.MrPhoenixProtocol;
    return
catch
    warning('Regular CSA structure was not found!')
end

% This is temporary prototype code until dicm2nii figures out how to read
% multiple CSA fields.
try
    csa = char(h.CSASeriesHeaderInfoX(:)');
    disp('Reading irregular CSA! FIXME!')
    return
catch
    error('Could not read CSA')
end
