function xps = fwf_xps_from_gwfl(gwfl, rfl, dtl, gamma_nuc)
% function xps = fwf_xps_from_gwfl(gwfl, rfl, dtl, gamma_H1)

if nargin < 4
    gamma_nuc = fwf_gamma_from_nuc();
end

n_vols = numel(gwfl);

bt     = zeros(n_vols, 6);
mt     = zeros(n_vols, 6);
gamma  = zeros(n_vols, 3);
gMom_0 = zeros(n_vols, 3);
gMom_1 = zeros(n_vols, 3);
gMom_2 = zeros(n_vols, 3);
gMom_3 = zeros(n_vols, 3);

gMaxXYZ= zeros(n_vols, 3);
sMaxXYZ= zeros(n_vols, 3);

for i = 1:n_vols

    gwf = gwfl{i};
    rf  = rfl{i};
    dt  = dtl{i};

    gMaxXYZ(i,:) = max(abs(gwf),[], 1);
    sMaxXYZ(i,:) = max(diff(gwf,1,1)/dt,[],1);

    geff = gwf .* rf;
    qeff = cumsum(geff, 1) * dt;
    
    % B and M tensors
    M           = gamma_nuc^2 * (geff' * geff) * dt; % bV_omega in Nilsson et al (2017) NMR Biomed, Eq. 24
    B           = gamma_nuc^2 * (qeff' * qeff) * dt;

    % Voight-like notation to be compatible with mddMRI
    bt(i,:)     = B([1 5 9 2 3 6]) .* [1 1 1 sqrt(2) sqrt(2) sqrt(2)];
    mt(i,:)     = M([1 5 9 2 3 6]) .* [1 1 1 sqrt(2) sqrt(2) sqrt(2)];

    % Exchange weighting
    gamma(i,:)  = gwf_to_tex(gwf, rf, dt);

    % Gradient moments
    gMom_0(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 0, 0);
    gMom_1(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 1, 0);
    gMom_2(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 2, 0);
    gMom_3(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 3, 0);

end


% XPS
xps.n        = n_vols;
xps.bt       = bt;
xps.b        = sum(xps.bt(:,1:3), 2);
xps.b_shape  = fwf_1x6_to_shape(xps.bt);
xps.b_rank   = fwf_1x6_to_rank(xps.bt);
xps.mt       = mt;
xps.m        = sum(xps.mt(:,1:3), 2);
xps.m_shape  = fwf_1x6_to_shape(xps.mt);
xps.m_rank   = fwf_1x6_to_rank(xps.mt);

xps.bm_shape = fwf_1x6_to_shape(xps.bt .* xps.mt .* 1./[1 1 1 sqrt(2) sqrt(2) sqrt(2)]);

xps.gamma    = gamma/3; % Using Arthur convention

xps.gMom_0   = gMom_0;
xps.gMom_1   = gMom_1;
xps.gMom_2   = gMom_2;
xps.gMom_3   = gMom_3;

xps.gMaxXYZ  = gMaxXYZ;
xps.sMaxXYZ  = sMaxXYZ;

% Some legacy stuff
tmp          = tm_1x6_to_tpars(bt);
xps.b_delta  = tmp.delta;

