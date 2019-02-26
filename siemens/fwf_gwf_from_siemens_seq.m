function [gwf, rf, dt] = fwf_gwf_from_siemens_seq(seq)
% function [gwf, rf, dt] = fwf_gwf_from_siemens_seq(seq)
% 
% Returns the waveform that was actually used on the scanner. The waveform
% is interpolated at the actual raster time, and is scaled in amplitude to
% match the maximal requested b-value. However, it is not rotated in any
% particular direction!

if ~any(seq.rot_mode ~= [2 3 5])
    error('Rotation mode not supported!')
end

if seq.post_wf_mode > 1
    error('Post-wf mode not supported!')
end

if seq.header_mode ~= 2
    error('Header mode does not contain extended info!')
end

[wf1, wf2] = fwf_wf_from_seq(seq.wf_stored);

if seq.rot_mode == 3
    wf1(:,2:3) = 0;
    wf2(:,2:3) = 0;
end

n1 = seq.d_pre / 10;
n2 = seq.d_post / 10;
nz = seq.d_pause / 10;

ga = fwf_gwf_interp_siemens(wf1, n1);
gb = fwf_gwf_interp_siemens(wf2, n2);
gz = zeros(nz, 3);

gwf = [ga; gz; gb];

mid = round(size(ga,1)+size(gz,1)/2);
rf  = ones(size(gwf,1),1);
rf(mid:end) = -1;

dt = 10e-6;

b_curr = trace(gwf_to_bt(gwf, rf, dt));

gwf = gwf * sqrt(seq.b_max_requ*1e6/b_curr);

end


function [wf1, wf2] = fwf_wf_from_seq(wf_stored)

for i = 1:6
    if i <= 3
        wf1(:,i) = wf_stored.data{i};
    else
        wf2(:,i-3) = wf_stored.data{i};
    end
end

end





