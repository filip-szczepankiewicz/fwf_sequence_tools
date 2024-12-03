function csa = fwf_csa_from_siemens_hdr(h, do_verbose) %#ok<INUSD>
% function csa = fwf_csa_from_siemens_hdr(h)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% Based on the dicom header reader at https://github.com/xiangruili/dicm2nii

if nargin < 2
    do_verbose = 0;
end

csa_names = {...
    'CSASeriesHeaderInfo.MrPhoenixProtocol'
    'MrPhoenixProtocol'
    'SharedFunctionalGroupsSequence.Item_1.CSASeriesHeaderInfo.Item_1.MrPhoenixProtocol'
    };


for i = 1:numel(csa_names)
    try
        csa = eval(['h.' csa_names{i}]); % Terrible, but works
        return

    catch me
        if do_verbose
            disp(me.message);
        end

    end
end