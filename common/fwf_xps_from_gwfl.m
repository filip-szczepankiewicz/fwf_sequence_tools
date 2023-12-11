function xps = fwf_xps_from_gwfl(gwfl, rfl, dtl, s_ind, wf_ind)
% function xps = fwf_xps_from_gwfl(gwfl, rfl, dtl, s_ind, wf_ind)

n_vols = numel(gwfl);

if nargin < 4
    s_ind = ones(n_vols,1);
end

if nargin < 5
    wf_ind = ones(n_vols,1);
end

bt     = zeros(n_vols, 6);
mt     = zeros(n_vols, 6);
btmt   = zeros(n_vols, 6);
gamma  = zeros(n_vols, 3);
gMom_0 = zeros(n_vols, 3);
gMom_1 = zeros(n_vols, 3);
gMom_2 = zeros(n_vols, 3);
gMom_3 = zeros(n_vols, 3);

for i = 1:n_vols

    gwf = gwfl{i};
    rf  = rfl{i};
    dt  = dtl{i};

    % Gaussian and restricted
    [B, M]      = gwf_to_spectral_moments(gwf, rf, dt);
    bt(i,:)     = tm_3x3_to_1x6( B );
    mt(i,:)     = tm_3x3_to_1x6( M );
    btmt(i,:)   = tm_3x3_to_1x6( B.*M );

    % Exchange weighting
    gamma(i,:)  = gwf_to_tex(gwf, rf, dt);

    % Gradient moments
    gMom_0(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 0, 0);
    gMom_1(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 1, 0);
    gMom_2(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 2, 0);
    gMom_3(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 3, 0);

end

b_par  = tm_1x6_to_tpars(bt);
m_par  = tm_1x6_to_tpars(mt);
bm_par = tm_1x6_to_tpars(btmt);


% XPS
xps.n        = n_vols;

xps.bt       = bt;
xps.b        = b_par.trace;
xps.b_delta  = b_par.delta;
xps.b_eta    = b_par.eta;

xps.mt       = mt;
xps.m        = m_par.trace;
xps.m_delta  = m_par.delta;
xps.m_eta    = m_par.eta;

xps.btmt     = btmt;
xps.bm       = bm_par.trace;
xps.bm_delta = bm_par.delta;
xps.bm_eta   = bm_par.eta;

xps.gamma    = gamma/3; % Using Arthur convention

xps.gMom_0   = gMom_0;
xps.gMom_1   = gMom_1;
xps.gMom_2   = gMom_2;
xps.gMom_3   = gMom_3;

xps.s_ind    = s_ind;
xps.wf_ind   = wf_ind;





