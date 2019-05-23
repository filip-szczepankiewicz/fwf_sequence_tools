function [R3x3, R1x9] = fwf_rm_from_uvec(u, mode)
% function R = fwf_rm_from_uvec(u, mode)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% u (nx3) is matrix of vectors.

n = size(u,1);

R3x3 = zeros(3,3,n);
R1x9 = zeros(n,9);

for i = 1:n
    
    switch mode
        case 2
            tmp = eye(3);
            
        case {3, 5}
            tmp = fwf_uvec_to_rmsc(u(i,1), u(i,2), u(i,3), 0);
            
        otherwise
            error(['Rotation mode not supported (' num2str(p.rot_mode) ')'])
    end

    R3x3(:,:,i) = tmp;
    R1x9(i,:)   = tmp(:)';
end