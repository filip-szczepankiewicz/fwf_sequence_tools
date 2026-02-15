function res = seq_from_csa_v1p50(csa)
% function res = fwf.silu.seq_from_csa_v1p50(csa)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% csa is the private Siemens header found in:
% h.CSASeriesHeaderInfo.MrPhoenixProtocol
%
% NOTE: This function must be expanded with version control as the position
% and meaning of each field may change!


str_list = {...
    
% UI parameters
'sWipMemBlock.alFree[1]	 = 	',                  'study_nr',     'enum';
'sWipMemBlock.alFree[2]	 = 	',                  'wf_nr',        'enum';
'sWipMemBlock.alFree[3]	 = 	',                  'rot_mode',     'enum';
'sWipMemBlock.alFree[4]	 = 	',                  'norm_mode',    'enum';
'sWipMemBlock.alFree[5]	 = 	',                  'post_wf_mode', 'enum';
'sWipMemBlock.alFree[6]	 = 	',                  'timing_mode',  'enum';
'sWipMemBlock.alFree[7]	 = 	',                  'pause_mode',   'enum';
'sWipMemBlock.alFree[8]	 = 	',                  'bg_mode',      'enum';
'sWipMemBlock.alFree[9]	 = 	',                  'header_mode',  'enum';

% sequence timing
'sWipMemBlock.alFree[16]	 = 	',              'd_pre_max',    'µs';
'sWipMemBlock.alFree[17]	 = 	',              'd_post_max',   'µs';
'sWipMemBlock.alFree[18]	 = 	',              'd_pause_min',  'µs';

'sWipMemBlock.alFree[23]	 = 	',              't_min_start1', 'µs';
'sWipMemBlock.alFree[24]	 = 	',              't_min_start2', 'µs';

% validation params
'sWipMemBlock.adFree[1]	 = 	',                  'b_lim_gamp',   'mm2/ms';
'sWipMemBlock.adFree[2]	 = 	',                  'b_lim_slew',   'mm2/ms';
'sWipMemBlock.adFree[3]	 = 	',                  'b_max_requ',   'mm2/ms';
'sWipMemBlock.adFree[4]	 = 	',                  'gamp_max',     'mT/m';
'sWipMemBlock.adFree[5]	 = 	',                  'slew_max',     'T/m/s';
'sWipMemBlock.adFree[6]	 = 	',                  'bg_gamp_max',  'mT/m';
'sWipMemBlock.adFree[7]	 = 	',                  'bg_mom0_max',  'unit';
'sWipMemBlock.adFree[8]	 = 	',                  'res_mom0_max', 'unit';
'sWipMemBlock.adFree[9]	 = 	',                  'didi_nrm_max', '1';

% waveform info
'sWipMemBlock.alFree[19]	 = 	',              'study_nr_act', 'enum';
'sWipMemBlock.alFree[25]	 = 	',              'n_unique_wfs', '1';
'sWipMemBlock.alFree[26]	 = 	',              'wfind_01',     'enum';
'sWipMemBlock.alFree[27]	 = 	',              'wfind_02',     'enum';
'sWipMemBlock.alFree[28]	 = 	',              'wfind_03',     'enum';
'sWipMemBlock.alFree[29]	 = 	',              'wfind_04',     'enum';
'sWipMemBlock.alFree[30]	 = 	',              'wfind_05',     'enum';
'sWipMemBlock.alFree[31]	 = 	',              'wfind_06',     'enum';
'sWipMemBlock.alFree[32]	 = 	',              'wfind_07',     'enum';
'sWipMemBlock.alFree[33]	 = 	',              'wfind_08',     'enum';
'sWipMemBlock.alFree[34]	 = 	',              'wfind_09',     'enum';
'sWipMemBlock.alFree[35]	 = 	',              'wfind_10',     'enum';

% SRR info
'sWipMemBlock.alFree[21]	 = 	',              'srr_nrot',     '1';
'sWipMemBlock.alFree[22]	 = 	',              'srr_rind',     '1';

% loaded waveform in base 64
'sWipMemBlock.tFree	 = 	',                      'wf_stored',    'str';

% Siemens imaging parameters
'tSequenceFileName	 = 	',                      'seq_dll_fn',   'str';
'sDiffusion.lDiffWeightings	 = 	',              'no_bvals',     'int';
'sProtConsistencyInfo.flNominalB0	 = 	',      'B0',           'T';
'sKSpace.lBaseResolution	 = 	',              'MatrixSize',   'int';
'sKSpace.lPhaseEncodingLines	 = 	',          'MatrixSizePh', 'int';
'sSliceArray.asSlice[0].dReadoutFOV	 = 	',      'FOVr',         'mm';
'sSliceArray.asSlice[0].dPhaseFOV	 = 	',      'FOVp',         'mm';
'sPat.lAccelFactPE	 = 	',                      'iPAT',         'int';
'sSliceArray.asSlice[0].dThickness	 = 	',      'SliceThick',   'mm';
'tSequenceFileName	 = 	',                      'SeqName',      'str';
'tProtocolName	 = 	',                          'ProtName',     'str';
'sSliceAcceleration.lMultiBandFactor	 = 	',  'MBFactor',     'int';
'sSliceAcceleration.lFOVShiftFactor	 = 	',      'FOVShift',     'int';

};


for i = 1:size(str_list, 1)
    
    ind = strfind(csa, str_list{i,1});
    ind2 = ind+length(str_list{i,1});
    
    if isempty(ind)
        disp(['Failed to parse: ' str_list{i,2}])
    end
    
    if strcmp('str', str_list{i,3})
        val = sscanf(csa(ind2:end), '%s', 1);
        val = strrep(val, '""', '');
        
        if strcmp('sWipMemBlock.tFree	 = 	', str_list{i,1}) && ~strcmp('EMPTY', val)
            val = fwf_b64_to_data(val);
            res.fwf_seq_version = str2double(val.version);
            res.unit.fwf_seq_version_unit = 'ordinal';
        end
        
    else
        val = sscanf(csa(ind2:end), '%g', 1);
        if isempty(val); val = 0.0; end
        
    end
    
    res.(str_list{i,2}) = val;
    
end




for i = 1:res.no_bvals
    
    bval_str = ['sDiffusion.alBValue['   num2str(i-1) ']'];
    avgs_str = ['sDiffusion.alAverages[' num2str(i-1) ']'];
    
    
    % Get the bvalue list requested in the UI
    ind  = strfind(csa, bval_str);
    ind2 = ind+length(bval_str);
    ind3 = strfind(csa(ind2:end), '=');
    
    if isempty(ind3)
        val = 1;
    else
        ind4 = ind3(1)+ind2;
        val = sscanf(csa((ind4):(ind4+10)), '%g', 1);
    end
    
    res.bval_req(i) = val;
    
    
    
    % Get the averages requested in the UI
    ind  = strfind(csa, avgs_str);
    ind2 = ind+length(avgs_str);
    ind3 = strfind(csa(ind2:end), '=');
    
    if isempty(ind3)
        val = 1;
    else
        ind4 = ind3(1)+ind2;
        val = sscanf(csa((ind4):(ind4+10)), '%g', 1);
    end
    
    res.avgs_req(i) = val;
    
end



for i = 1:size(str_list, 1)
    res.unit.([str_list{i,2} '_unit']) = str_list{i,3};
end

res.unit.bval_req_unit = 's/mm2';
res.unit.avgs_rew_unit = 'int';


