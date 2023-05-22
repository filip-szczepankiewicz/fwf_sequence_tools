function [gwf, rf, dt] = fwf_gwf_create_wedeen06(g, s, d, dp, dt)
% function [gwf, rf, dt] = fwf_gwf_create_wedeen06(g, s, d, dp, dt)

% Diffusion encoding with 2D gradient trajectories yields natural contrast for 3D fiber orientation
% V. J. Wedeen, G. Dai, W-Y. I. Tseng, R. Wang, T. Benner, ISMRM 2006
% https://cds.ismrm.org/ismrm-2006/files/00851.pdf

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 25.5e-3;
    dp = 8e-3+6e-3;
    dt = 0.1e-3;
    [gwf, rf, dt] = fwf_gwf_create_wedeen06(g, s, d, dp, dt);
    fwf_gwf_plot_wf2d(gwf, rf, dt)
    return
end


na = round(d/dt);
nb = floor(na/2);
nc = na-nb;

np = ceil(dp/dt);

ta = fwf_gwf_create_trapezoid(g, s, dt, na);
tb = fwf_gwf_create_trapezoid(g, s, dt, nb);
tc = fwf_gwf_create_trapezoid(g, s, dt, nc);

wfz = zeros(np, 3);

gx = [tb -tc];
gy = ta;
gz = ta*0;

gwf = [gx' gy' gz'];
gwf = [gwf; wfz; gwf];

rf = ones(size(gwf,1),1);
mind = round(size(gwf,1)/2);
rf(mind:end) = -1;


% Assume that we want PTE and L2-norm
[gwf, rf, dt] = fwf_gwf_force_shape(gwf, rf, dt, 'sym');

gwf = gwf / max(my_norm(gwf, 2))*g;