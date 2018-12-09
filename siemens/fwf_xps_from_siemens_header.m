function xps = fwf_xps_from_siemens_header(h)
% function xps = fwf_xps_from_siemens_header(h)
%
% Create experimental parameter structure (XPS) compatible with the
% multidimensional diffusion toolbox (required to execute function):
% https://github.com/markus-nilsson/md-dmri
%
% h is series dicom header extracted with xiangruili/dicm2nii
% https://se.mathworks.com/matlabcentral/fileexchange/42997-xiangruili-dicm2nii

csa           = fwf_csa_from_siemens_header(h);
seq           = fwf_seq_from_siemens_csa(csa);
[gwf, rf, dt] = fwf_gwf_from_siemens_seq(seq);

bt  = gwf_to_bt(gwf, rf, dt);
nbt = bt/trace(bt);

b   = h.bval * 1e6; % s/m2
u   = h.bvec;

[R3x3, R1x9] = fwf_rm_from_uvec(u, seq.rot_mode);

btl = zeros(numel(b), 6);

for i = 1:numel(b)
    rt = R3x3(:,:,i) * nbt * R3x3(:,:,i)';
    btl(i,:) = tm_3x3_to_1x6(rt) * b(i) ;
end

xps = mdm_xps_from_bt(btl);

xps.u_from_bvec = u;
xps.rotmat      = R1x9;

xps.te = ones(xps.n, 1) * h.EchoTime /1000;
xps.tr = ones(xps.n, 1) * h.RepetitionTime /1000;




