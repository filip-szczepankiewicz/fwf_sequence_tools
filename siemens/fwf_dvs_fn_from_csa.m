function dvs_fn = fwf_dvs_fn_from_csa(csa)
% function dvs_fn = fwf_dvs_fn_from_csa(csa)

str_fnd = 'sDiffusion.sFreeDiffusionData.sComment.';
idstr   = '# ''';

ind = strfind(csa, str_fnd);
ind2 = ind+length(str_fnd);

for j = 1:numel(ind)
    tmp_str = csa(ind2(j):(ind2(j)+20));
    
    ind3 = strfind(tmp_str, idstr);
    
    if ~isempty(ind3)
        dvs_fn(j) = tmp_str(ind3+length(idstr));
    end
    
end