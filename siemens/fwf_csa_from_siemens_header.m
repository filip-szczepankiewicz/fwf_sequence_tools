function csa = fwf_csa_from_siemens_header(h)
% function csa = fwf_csa_from_siemens_header(h)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden

csa = h.CSASeriesHeaderInfo.MrPhoenixProtocol;
  