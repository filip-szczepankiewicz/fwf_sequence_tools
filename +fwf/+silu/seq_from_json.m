function res = fwf_seq_from_siemens_json(json)
% function res = fwf_seq_from_siemens_json(json)
% By Markus Nilsson
% Lund University, Lund, Sweden
%
% json created by a modified dcm2niix binary
%
% NOTE: This function must be expanded with version control as the position
% and meaning of each field may change!


str_list = {...
    
% UI parameters
'alFree[21]',              'study_nr',     'enum';
'alFree[22]',              'wf_nr',        'enum';
'alFree[23]',              'rot_mode',     'enum';
'alFree[24]',              'norm_mode',    'enum';
'alFree[25]',              'post_wf_mode', 'enum';
'alFree[26]',              'timing_mode',  'enum';
'alFree[27]',              'pause_mode',   'enum';
'alFree[28]',              'bg_on',        'enum';
'alFree[29]',              'header_mode',  'enum';
'alFree[31]',              'b_max',        'mm2/ms';
'alFree[32]',              'd_pre',        'µs';
'alFree[33]',              'd_post',       'µs';
'alFree[34]',              'd_pause',      'µs';

% sequence timing
'alFree[41]',              'd_pre_max',    'µs';
'alFree[42]',              'd_post_max',   'µs';
'alFree[43]',              'd_pause_min',  'µs';
'alFree[44]',              'd_pause_max',  'µs';

'alFree[60]',               't_start',      'µs'; % v1.19

% validation params
'alFree[45]',              'study_nr_curr','enum';
'alFree[46]',              'wf_nr_curr',   'enum';
'alFree[47]',              'b_max_gamp',   'mm2/ms';
'alFree[48]',              'b_max_slew',   'mm2/ms';
'alFree[49]',              'b_max_requ',   'mm2/ms';

% waveform info
'alFree[50]',              'gamp',         'mT/m*1000';
'alFree[51]',              'slew',         'T/m/s*1000';
'alFree[52]',              'B_FA',         '1*1000';
'alFree[53]',              'didi_norm',    '1*1000';

% b-tensor
'alFree[54]',              'Bxx',          'ms/µm2*1000';
'alFree[55]',              'Byy',          'ms/µm2*1000';
'alFree[56]',              'Bzz',          'ms/µm2*1000';
'alFree[57]',              'Bxy',          'ms/µm2*1000';
'alFree[58]',              'Bxz',          'ms/µm2*1000';
'alFree[59]',              'Byz',          'ms/µm2*1000';

% balance gradient
'adFree[8]',              'bg_ampx',      'mT/m';
'adFree[9]',              'bg_ampy',      'mT/m';
'adFree[10]',             'bg_ampz',      'mT/m';
'adFree[11]',             'bg_0mom',      'mTs/m';

% loaded waveform in base 64
'WipMemBlock',             'wf_stored',    'str';

% Siemens imaging parameters
'PulseSequenceDetails',             'seq_dll_fn',   'str';
'ImagingFrequency',                 'f0',           'MHz';
'BaseResolution',                   'MatrixSize',   'int';
'PhaseEncodingSteps',               'MatrixSizePh', 'int';
'ParallelReductionFactorInPlane',   'iPAT',         'int';
'SliceThickness',                   'SliceThick',   'mm';
'SequenceName',                     'SeqName',      'str';
'ProtocolName',                     'ProtName',     'str';
'MultibandAccelerationFactor',      'MBFactor',     'int';

};

% json

for i = 1:size(str_list, 1)

    % Search for field name
    fn = str_list{i,1};
    fn = strrep(fn, '[', '_');
    fn = strrep(fn, ']', '_');

    if (contains(fn, 'alFree')) || (contains(fn, 'adFree'))
        fn = sprintf('FWF_%s', fn);
    end

    if (isfield(json, fn))

        val = json.(fn);

        if (strcmp(fn, 'WipMemBlock'))
            val = fwf_b64_to_data(val);
            res.fwf_seq_version = str2double(val.version);
            res.unit.fwf_seq_version_unit = 'ordinal';        
        end

        res.(str_list{i,2}) = val;


    else
        fprintf('Did not find: %s\n', str_list{i});
    end    
    
    
end



