function is_fwf = is_fwf_from_csa(csa)
% function is_fwf = fwf.silu.is_fwf_from_csa(csa)

try
    seq = fwf.silu.seq_from_csa(csa);
    
    if strcmp(seq.wf_stored.name, 'MDMR')
        is_fwf = 1;
    else
        is_fwf = 0;
    end
    
catch
    is_fwf = 0;
    
end