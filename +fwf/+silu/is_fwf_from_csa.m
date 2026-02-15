function is_fwf = fwf_is_fwf_from_siemens_csa(csa)
% function is_fwf = fwf_is_fwf_from_siemens_csa(csa)

try
    seq = fwf_seq_from_siemens_csa(csa);
    
    if strcmp(seq.wf_stored.name, 'MDMR')
        is_fwf = 1;
    else
        is_fwf = 0;
    end
    
catch
    is_fwf = 0;
    
end