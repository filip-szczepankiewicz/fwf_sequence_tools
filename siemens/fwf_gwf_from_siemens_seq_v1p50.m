function [gwfc, rfc, dtc, ind] = fwf_gwf_from_siemens_seq_v1p50(seq)
% function [gwfc, rfc, dtc, ind] = fwf_gwf_from_siemens_seq_v1p50(seq)
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

[res, ind] = fwf_wf_from_wf_stored(seq.wf_stored);

for i = 1:numel(res)
    n1 = res(i).dur1 / 10;
    n2 = res(i).dur2 / 10;
    nf = res(i).tim1 / 10;
    nz = res(i).paus / 10;

    if seq.rot_mode == 3
        f = [1 0 0];
    else
        f = [1 1 1];
    end

    ga = fwf_gwf_interp(res(i).wf1.*f, n1);
    gb = fwf_gwf_interp(res(i).wf2.*f, n2);
    gf = zeros(nf, 3);
    gz = zeros(nz, 3);

    gw = [gf; ga; gz; gb];

    mid = round(nf+n1+nz/2); % WIP do this properly
    rf  = ones(size(gw,1),1);
    rf(mid:end) = -1;

    dt = 10e-6;

    wf = gw/max(abs(gw(:)));

    gwfc{i} = wf;
    rfc{i}  = rf;
    dtc{i}  = dt;
end
end


function [res, ind] = fwf_wf_from_wf_stored(wf_stored)

numWF = (wf_stored.blocks-1)/7;

for j = 1:numWF

    bb = (j-1)*7+1;

    res(j).dur1 = wf_stored.data{bb}(1);
    res(j).dur2 = wf_stored.data{bb}(2);
    res(j).tim1 = wf_stored.data{bb}(3);
    res(j).tim2 = wf_stored.data{bb}(4);
    res(j).paus = res(j).tim2-res(j).dur1-res(j).tim1;

    for i = 1:6
        if i <= 3
            res(j).wf1(:,i) = wf_stored.data{bb+i};
        else
            res(j).wf2(:,i-3) = wf_stored.data{bb+i};
        end
    end
end

ind = (wf_stored.data{wf_stored.blocks}+1)';

end





