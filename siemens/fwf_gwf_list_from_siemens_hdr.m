function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr(h)
% function [gwfc, rfc, dtc] = fwf_gwf_list_from_siemens_hdr(h)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden
% Returns cell array of actually executed waveforms.
% Completely unvalidated.

xps = fwf_xps_from_siemens_hdr(h);

[gwf, rf, dt] = fwf_gwf_from_siemens_hdr(h);

bref = trace(gwf_to_bt(gwf, rf, dt));

for i = 1:xps.n
   
    R = fwf_rm_1x9to3x3(xps.rotmat(i,:));
    scale = sqrt(xps.b(i)/bref);
    gwfc{i} = (R * gwf')' * scale;
    rfc{i} = rf;
    dtc{i} = dt;
    
%     berror = (trace(gwf_to_bt(gwfc{i}, rfc{i}, dtc{i})) - xps.b(i))/1e9

end