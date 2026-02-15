function seq = seq_from_csa(csa)
% function seq = fwf.silu.seq_from_csa(csa)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% csa is the private Siemens header

ver = fwf.silu.ver_from_csa(csa);

if isempty(ver)
    error('Bad!')
end

if ver < 2.00
    seq = fwf.silu.seq_from_csa_v1p00(csa);

else
    seq = fwf.silu.seq_from_csa_v2p00(csa);

end