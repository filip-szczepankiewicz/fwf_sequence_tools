function seq = seq_from_hdr(h, do_verbose)
% function seq = fwf.silu.seq_from_hdr(h, do_verbose)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% h is series dicom header extracted with xiangruili/dicm2nii
% https://se.mathworks.com/matlabcentral/fileexchange/42997-xiangruili-dicm2nii

if nargin < 2
    do_verbose = 0;
end

% Collect sequence specific parameters from the CSA header
csa = fwf.silu.csa_from_hdr(h);
seq = fwf.silu.seq_from_csa(csa);


% Collect the basic parameters from the dicom header
str_list = {...

'EchoTime',                     'te',               'ms';
'RepetitionTime',               'tr',               'ms';
'EffectiveEPIEchoSpacing',      'EffEchoSpacing',   'ms';
'NumberOfPhaseEncodingSteps',   'PhaseSteps',       '1';
'EchoTrainLength',              'TrainLength',      '1';
'PixelBandwidth',               'PixBW',            'Hz/pix';
'MagneticFieldStrength',        'B0',               'T';

};


for i = 1:size(str_list, 1)
    try
        seq.(str_list{i,2})                = h.(str_list{i,1});
        seq.unit.([str_list{i,2} '_unit']) = str_list{i,3};
    catch
        if do_verbose
            warning(['Failed to parse: ' str_list{i,1}])
        end
        
        seq.(str_list{i,2})                = nan;
    end
end



% Calculate derived parameters
% Partial Fourier factor
seq.PartialFourier = seq.PhaseSteps / seq.MatrixSizePh;
seq.unit.PartialFourier_unit = '1';


% WIP: include phase subsampling in PFF calc
% WIP: add info on fat saturation

