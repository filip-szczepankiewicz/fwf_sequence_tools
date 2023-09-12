function seq = fwf_seq_from_siemens_csa(csa)
% function seq = fwf_seq_from_siemens_csa(csa)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% csa is the private Siemens header found in:
% h.CSASeriesHeaderInfo.MrPhoenixProtocol

ver = fwf_ver_from_siemens_csa(csa);

if ver < 2.00
    seq = fwf_seq_from_siemens_csa_v1p00(csa);

else
    seq = fwf_seq_from_siemens_csa_v2p00(csa);

end