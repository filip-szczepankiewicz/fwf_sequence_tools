function [u, n] = dvs_from_csa(csa)
% function u = fwf.silu.dvs_from_csa(csa)
% These are most likely in patient coord system.

str_fnd_n_samp = 'sDiffusion.sFreeDiffusionData.asDiffDirVector.__attribute__.size	 = ';

ind = strfind(csa, str_fnd_n_samp);

n_samp = sscanf(csa((ind:(ind+10))+length(str_fnd_n_samp)), '%g', 1);

dir_str = {'.dSag', '.dCor', '.dTra'};

u = zeros(n_samp, 3);

for i = 0:(n_samp-1)
    
    str_fnd = ['sDiffusion.sFreeDiffusionData.asDiffDirVector[' num2str(i) ']'];
    
    for j = 1:numel(dir_str)
        str_fnd_dir = [str_fnd dir_str{j} '	 = '];
        
        ind = strfind(csa, str_fnd_dir);
        
        if ~isempty(ind)
            ind2 = ind+length(str_fnd_dir);
            u(i+1, j) = sscanf(csa(ind2:(ind2+20)), '%g', 1);
        end
    end
    
end

n = sqrt(sum(u.^2, 2));


%% WIP
% Take into account averages
% Take into account b0 images
% Take into account multiple b-vals in UI
% Check ordering of averages
% Write function for non .dvs-based directions