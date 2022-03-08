function [gwfc, rfc, dtc] = fwf_gwf_from_siemens_seq_v1p00(seq)
% function [gwfc, rfc, dtc] = fwf_gwf_from_siemens_seq_v1p00(seq)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
% 
% Returns the waveform that was actually used on the scanner. The waveform
% is interpolated at the actual raster time, and its amplitude is
% normalized to 1. 

if ~any(seq.rot_mode ~= [2 3 5])
    error('Rotation mode not supported yet!')
end

if seq.post_wf_mode > 1
    error('Post-wf mode not supported yet!')
end

if seq.header_mode ~= 2
    error('Header mode does not contain extended info!')
end

[wf1, wf2] = fwf_wf_from_wf_stored(seq.wf_stored);

if seq.rot_mode == 3
    wf1(:,2:3) = 0;
    wf2(:,2:3) = 0;
end

n1 = seq.d_pre / 10;
n2 = seq.d_post / 10;
nz = seq.d_pause / 10;

ga = fwf_gwf_interp(wf1, n1);
gb = fwf_gwf_interp(wf2, n2);
gz = zeros(nz, 3);

gw = [ga; gz; gb];

mid = round(size(ga,1)+size(gz,1)/2);
rf  = ones(size(gw,1),1);
rf(mid:end) = -1;

dt = 10e-6;

gw = gw/max(abs(gw(:)));

if seq.t_start
    ns = round(seq.t_start*1e-6/dt);
    gw = [zeros(ns, 3); gw];
    rf  = [ones(ns, 1);  rf ];
    
    ne = sum(rf);
    gw = [gw; zeros(ne, 3)];
    rf  = [rf;  -ones(ne, 1)];
end

% Repach as cells to be compatible with multi-wf code
gwfc{1} = gw;
rfc{1}  = rf;
dtc{1}  = dt;

end


function [wf1, wf2] = fwf_wf_from_wf_stored(wf_stored)

for i = 1:6
    if i <= 3
        wf1(:,i) = double(wf_stored.data{i});
    else
        wf2(:,i-3) = double(wf_stored.data{i});
    end
end

end





