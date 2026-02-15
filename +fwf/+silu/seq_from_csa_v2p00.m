function res = fwf_seq_from_siemens_csa_v2p00(csa)
% function res = fwf_seq_from_siemens_csa_v2p00(csa)
% By Filip Szczepankiewicz
% Lund University, Lund, Sweden
%
% csa is the private Siemens header found by calling:
% fwf_csa_from_siemens_hdr
%
% NOTE: This function is very dependent on sequence version!


str_list = {...

% UI parameters
'sWipMemBlock.alFree[1]	 = 	',                  'rot_mode',     'enum';
'sWipMemBlock.alFree[2]	 = 	',                  'norm_mode',    'enum';
'sWipMemBlock.alFree[3]	 = 	',                  'spoil_mode',   'enum';
'sWipMemBlock.alFree[4]	 = 	',                  'pause_mode',   'enum';
'sWipMemBlock.alFree[5]	 = 	',                  'd_pause',      'µs';
'sWipMemBlock.alFree[6]	 = 	',                  'd_pre',        'µs';
'sWipMemBlock.alFree[7]	 = 	',                  'd_post',       'µs';


% sequence timing
'sWipMemBlock.alFree[21]	 = 	',              'd_pre_max',    'µs';
'sWipMemBlock.alFree[22]	 = 	',              'd_post_max',   'µs';
'sWipMemBlock.alFree[23]	 = 	',              'd_pause_min',  'µs';
'sWipMemBlock.alFree[24]	 = 	',              'd_pause_max',  'µs';
'sWipMemBlock.alFree[25]	 = 	',              't_start',      'µs';
'sWipMemBlock.alFree[26]	 = 	',              'd_grad_rast',  'µs';

% sequence info
'sWipMemBlock.adFree[1]	 = 	',                  'gamp_max',     'mT/m';
'sWipMemBlock.adFree[2]	 = 	',                  'seq_ver',      '1';
'sWipMemBlock.adFree[3]	 = 	',                  'bin_ver',      '1';
'sWipMemBlock.adFree[4]	 = 	',                  'b_max_pos',    's/mm^2';
'sWipMemBlock.adFree[5]	 = 	',                  'b_max_req',    's/mm^2';
'sWipMemBlock.adFree[6]	 = 	',                  'max_b_per_g2', 's/mm^2/(mT/m)^2';
'sWipMemBlock.tFree	 = 	',                      'bin_hash',     'str';

% Siemens imaging parameters
'tSequenceFileName	 = 	',                      'seq_fn',       'str';
'sDiffusion.lDiffWeightings	 = 	',              'no_bvals',     '1';
'sKSpace.lBaseResolution	 = 	',              'MatrixSize',   '1';
'sKSpace.lPhaseEncodingLines	 = 	',          'MatrixSizePh', '1';
'sSliceArray.asSlice[0].dReadoutFOV	 = 	',      'FOVr',         'mm';
'sSliceArray.asSlice[0].dPhaseFOV	 = 	',      'FOVp',         'mm';
'sPat.lAccelFactPE	 = 	',                      'iPAT',         '1';
'sSliceArray.asSlice[0].dThickness	 = 	',      'SliceThick',   'mm';
'tProtocolName	 = 	',                          'ProtName',     'str';
'sSliceAcceleration.lMultiBandFactor	 = 	',  'MBFactor',     '1';
'sSliceAcceleration.lFOVShiftFactor	 = 	',      'FOVShift',     '1';

};


for i = 1:size(str_list, 1)

    ind_start = strfind(csa, str_list{i,1});
    ind_end   = ind_start+length(str_list{i,1});

    if isempty(ind_start)
        disp(['Failed to find: ' str_list{i,2}])
    end

    if strcmp('str', str_list{i,3}) % String type
        val = sscanf(csa(ind_end:end), '%s', 1);
        val = strrep(val, '""', '');

    else % numerical type
        val = sscanf(csa(ind_end:end), '%g', 1);
    end

    res.(str_list{i,2}) = val;

end


for i = 1:res.no_bvals

    bval_str = ['sDiffusion.alBValue['   num2str(i-1) ']'];
    avgs_str = ['sDiffusion.alAverages[' num2str(i-1) ']'];

    % Get the bvalue list requested in the UI
    ind_start = strfind(csa, bval_str);
    ind_end   = ind_start+length(bval_str);
    ind3      = strfind(csa(ind_end:end), '=');

    if isempty(ind3)
        % Requested b-values of 0 are not stored in the csa, but they are real!
        val = 0.0;
    else
        ind4 = ind3(1)+ind_end;
        val = sscanf(csa((ind4):(ind4+10)), '%g', 1);
    end

    res.bval_req(i) = val;


    % Get the averages requested in the UI
    ind_start = strfind(csa, avgs_str);
    ind_end   = ind_start+length(avgs_str);
    ind3      = strfind(csa(ind_end:end), '=');

    if isempty(ind3)
        val = [];
        error('This should not happen!')
    else
        ind4 = ind3(1)+ind_end;
        val = sscanf(csa((ind4):(ind4+10)), '%g', 1);
    end

    res.avgs_req(i) = val;

end


for i = 1:size(str_list, 1)
    res.unit.([str_list{i,2} '_unit']) = str_list{i,3};
end

res.unit.bval_req_unit = 's/mm^2';
res.unit.avgs_req_unit = 'int';


