function [P, v_slice, v_phase] = fwf_nii2xyz(nii_fn)
% function [P, v_slice, v_phase] = fwf_nii2xyz(nii_fn)
% By Fsz
% Code based on https://brainder.org/2012/09/23/the-nifti-file-format/

h = mdm_nii_read_header(nii_fn);

ni = h.dim(2);
nj = h.dim(3);
nk = h.dim(4);

b = h.quatern_b;
c = h.quatern_c;
d = h.quatern_d;
a = sqrt(1-b^2-c^2-d^2);

q       = h.pixdim(1);
pix_dim = h.pixdim(2:4);

offset  = [h.qoffset_x; h.qoffset_y; h.qoffset_z];

R(1,1) = a^2+b^2-c^2-d^2;   R(1,2) = 2*(b*c-a*d);       R(1,3) = 2*(b*d+a*c);
R(2,1) = 2*(b*c+a*d);       R(2,2) = a^2+c^2-b^2-d^2;   R(2,3) = 2*(c*d-a*b);
R(3,1) = 2*(b*d-a*c);       R(3,2) = 2*(c*d+a*b);       R(3,3) = a^2+d^2-b^2-c^2;


v_slice = R*[0 0 1]';
v_phase = R*[0 1 0]';


P = zeros([ni nj nk 3]);

for i = 1:ni
    for j = 1:nj
        for k = 1:nk
            
            P(i,j,k,:) = R * [i; j; k] .* pix_dim .* [1 1 q]' + offset;
            
        end
    end
end

P = P / 1000; % Return in unit: meter



% sr_x = h.srow_x';
% sr_y = h.srow_y';
% sr_z = h.srow_z';
% p    = [sr_x; sr_y; sr_z; [0 0 0 1]] * [i; j; k; 1]



