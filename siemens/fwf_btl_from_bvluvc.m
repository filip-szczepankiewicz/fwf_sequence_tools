function [btl, R1x9] = fwf_btl_from_bvluvc(b, u, n, nbt, mode)
% function [btl, R1x9] = fwf_btl_from_bvluvc(b, u, n, nbt, mode)

switch mode
    
    case {5, 6}
        [R3x3, R1x9]  = fwf_rm_from_siemens_uvec(u, mode, n*2*pi);
        
        btl = zeros(numel(b), 6);
        
        for i = 1:numel(b)
            rt = R3x3(:,:,i) * nbt * R3x3(:,:,i)';
            btl(i,:) = tm_3x3_to_1x6(rt) * b(i) ;
        end
        
    otherwise
        error('Rotation mode not implemented!')
        
end






