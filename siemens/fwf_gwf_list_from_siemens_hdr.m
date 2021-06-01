function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr(h)
% function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr(h)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden
% Returns cell array of actually executed waveforms.
% Completely unvalidated.

xps = fwf_xps_from_siemens_hdr(h);

[gwf, rf, dt] = fwf_gwf_from_siemens_hdr(h);

bref = trace(fwf_bt_from_gwf(gwf, rf, dt, fwf_gamma_from_nuc(h.ImagedNucleus)));

for i = 1:xps.n
   
    R       = fwf_rm_3x3_from_1x9(xps.rotmat(i,:));
    scale   = sqrt(xps.b(i)/bref);
    gwfc{i} = (R * gwf')' * scale;
    rfc{i}  = rf;
    dtc{i}  = dt;
    
end