function [R3x3, R1x9] = fwf_rm_from_siemens_uvec(u, mode, ang)
% function [R3x3, R1x9] = fwf_rm_from_siemens_uvec(u, mode, ang)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% u (nx3) is matrix of unit vectors.

if nargin < 3
    ang = [];
end

n = size(u,1);

R3x3 = zeros(3,3,n);
R1x9 = zeros(n,9);

for i = 1:n
    
    switch mode
        case 2
            tmp = eye(3);
            
        case {3, 5}
            tmp = fwf_rmsc_from_uvec_and_ang(u(i,1), u(i,2), u(i,3), 0);
            
        case 6
            tmp = fwf_rmsc_from_uvec_and_ang(u(i,1), u(i,2), u(i,3), ang(i));
            
        otherwise
            error(['Rotation mode not supported (' num2str(p.rot_mode) ')'])
    end
    
    R3x3(:,:,i) = tmp;
    R1x9(i,:)   = fwf_rm_1x9_from_3x3(tmp);
end
