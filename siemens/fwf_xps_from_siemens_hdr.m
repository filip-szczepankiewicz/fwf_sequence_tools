function xps = fwf_xps_from_siemens_hdr(h)
% function xps = fwf_xps_from_siemens_hdr(h)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden
%
% Create experimental parameter structure (XPS) compatible with the
% multidimensional diffusion toolbox (REQUIRED to execute function):
% https://github.com/markus-nilsson/md-dmri
%
% h is series dicom header, for example extracted with xiangruili/dicm2nii (dicm_hdr)
% https://se.mathworks.com/matlabcentral/fileexchange/42997-xiangruili-dicm2nii

csa           = fwf_csa_from_siemens_hdr(h);
seq           = fwf_seq_from_siemens_csa(csa);
[gwf, rf, dt] = fwf_gwf_from_siemens_seq(seq);
[dvs, nrm]    = fwf_dvs_from_siemens_csa(csa);

bt  = gwf_to_bt(gwf, rf, dt);
nbt = bt/trace(bt); % normalized b-tensor, Tr(nbt) = 1.

try
    b = h.bval * 1e6; % s/m2
    u = h.bvec;
catch
    b = h.B_value * 1e6; % s/m2
    u = h.DiffusionGradientDirection';
end


if seq.rot_mode == 6
    b = [];
    u = [];
    n = [];
    
    for i = 1:numel(seq.bval_req)
        if seq.bval_req(i) == 0
            b = [b; 0];
            u = [u; [0 0 0]];
            n = [n; 0];
        else
            b = [b; ones(size(dvs,1), 1) * seq.bval_req(i) * 1e6 .* (~all(dvs==0, 2)) ];
            u = [u; dvs];
            n = [n; nrm];
        end
    end
    
    u = u ./ sqrt(sum(u.^2, 2));
    u(isnan(u)) = 0;
    
    nrm = n;
    
    % WIP: This is still not the correct rotation for u (dvs is not rotated with the FOV).
    
end


[R3x3, R1x9] = fwf_rm_from_siemens_uvec(u, seq.rot_mode, nrm*2*pi);

btl = zeros(numel(b), 6);

for i = 1:numel(b)
    rt = R3x3(:,:,i) * nbt * R3x3(:,:,i)';
    btl(i,:) = tm_3x3_to_1x6(rt) * b(i) ;
end

xps = mdm_xps_from_bt(btl);

xps.u_from_bvec = u;
% xps.dvs         = dvs;
xps.rotmat      = R1x9;

xps.te = ones(xps.n, 1) * h.EchoTime /1000;
xps.tr = ones(xps.n, 1) * h.RepetitionTime /1000;

%% WIP
% change calculation of b to be native to csa and seq info and not rely on bval/bvec

