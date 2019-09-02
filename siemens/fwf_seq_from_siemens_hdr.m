function seq = fwf_seq_from_siemens_hdr(h)
% function xps = fwf_seq_from_siemens_hdr(h)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% h is series dicom header extracted with xiangruili/dicm2nii
% https://se.mathworks.com/matlabcentral/fileexchange/42997-xiangruili-dicm2nii

% Collect as much as possible from the CSA
csa           = fwf_csa_from_siemens_hdr(h);
seq           = fwf_seq_from_siemens_csa(csa);

% Collect rest from DICOM header
str_list = {...
    
'EffectiveEPIEchoSpacing',      'EffEchoSpacing',   'ms';
'NumberOfPhaseEncodingSteps',   'PhaseSteps',       'int';
'EchoTrainLength',              'TrainLength',      'int';
'PixelBandwidth',               'PixBW',            'Hz/pix';

};


for i = 1:size(str_list, 1)
    try
        seq.(str_list{i,2})                = h.(str_list{i,1});
        seq.unit.([str_list{i,2} '_unit']) = str_list{i,3};
    catch me
        warning(['Failed to parse: ' str_list{i,1}])
        seq.(str_list{i,2})                = nan;
    end
end


% Calculate derived parameters

% Partial Fourier factor
seq.PartialFourier = seq.PhaseSteps / seq.MatrixSizePh;
seq.unit.PartialFourier_unit = '1';


% WIP: include phase subsampling in PFF calc
% WIP: add info on fat saturation