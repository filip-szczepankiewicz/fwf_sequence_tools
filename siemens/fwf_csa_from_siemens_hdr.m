function csa = fwf_csa_from_siemens_hdr(h)
% function csa = fwf_csa_from_siemens_hdr(h)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% Based on the dicom header reader at https://github.com/xiangruili/dicm2nii

csa_names = {...
    'CSASeriesHeaderInfo.MrPhoenixProtocol'
    'MrPhoenixProtocol'
    'SharedFunctionalGroupsSequence.Item_1.CSASeriesHeaderInfo.Item_1.MrPhoenixProtocol' % WIP: FIX ME!
    };


for i = 1:numel(csa_names)
    try
        csa = eval(['h.' csa_names{i}]); % Terrible, but matlab is tricky on this
        return

    catch me
        disp(me.message);

    end
end
