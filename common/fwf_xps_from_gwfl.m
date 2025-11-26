function xps = fwf_xps_from_gwfl(gwfl, rfl, dtl, gamma_nuc, tStart)
% function xps = fwf_xps_from_gwfl(gwfl, rfl, dtl, gamma_H1, tStart)

if nargin < 4 || isempty(gamma_nuc)
    gamma_nuc = fwf_gamma_from_nuc();
end

if nargin < 5
    tStart = nan;
end

if iscell(gwfl)
    n_vols = numel(gwfl);

else
    n_vols = size(gwfl,3);
end

bt     = zeros(n_vols, 6);
mt     = zeros(n_vols, 6);
gamma  = zeros(n_vols, 3);
gMom_0 = zeros(n_vols, 3);
gMom_1 = zeros(n_vols, 3);
gMom_2 = zeros(n_vols, 3);
gMom_3 = zeros(n_vols, 3);

gMaxXYZ= zeros(n_vols, 3);
sMaxXYZ= zeros(n_vols, 3);
gMaxNrm= zeros(n_vols, 1);
sMaxNrm= zeros(n_vols, 1);

if ~isempty(tStart)
    cts    = zeros(n_vols, 3);
    bgs    = zeros(n_vols, 1);

    if isscalar(tStart)
        tStart = ones(n_vols,1)*tStart;
    end
end


for i = 1:n_vols

    if iscell(gwfl)
        gwf = gwfl{i};
        rf  = rfl{i};
        dt  = dtl{i};

    else
        gwf = gwfl(:,:,i);
        rf  = rfl(:,i);
        dt  = dtl(i);

    end

    % Calculate parameters
    gMaxXYZ(i,:) = max(abs(gwf),[], 1);
    sMaxXYZ(i,:) = max(diff(gwf,1,1)/dt,[],1);

    gMaxNrm(i)   = max(vecnorm(gwf,2,2));
    sMaxNrm(i)   = max(vecnorm(diff(gwf,1,1)/dt, 2,2));

    geff = gwf .* rf;
    qeff = cumsum(geff, 1) * dt;

    % B and M tensors
    M           = gamma_nuc^2 * (geff' * geff) * dt; % [1/s/m2] bV_omega in Nilsson et al (2017) NMR Biomed, Eq. 24
    B           = gamma_nuc^2 * (qeff' * qeff) * dt; % [s/m2]

    % Voight-like notation to be compatible with mddMRI
    bt(i,:)     = B([1 5 9 2 3 6]) .* [1 1 1 sqrt(2) sqrt(2) sqrt(2)];
    mt(i,:)     = M([1 5 9 2 3 6]) .* [1 1 1 sqrt(2) sqrt(2) sqrt(2)];

    % Exchange weighting
    gamma(i,:)  = fwf_gwf_to_tex(gwf, rf, dt);

    % Gradient moments
    gMom_0(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 0, 0);
    gMom_1(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 1, 0);
    gMom_2(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 2, 0);
    gMom_3(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 3, 0);

    % Cross term sensitivity
    Ht       = cumsum(rf)*dt + tStart(i);
    cts(i,:) = gamma_nuc^2 * sum(qeff.*Ht) * dt;
    bgs(i)   = gamma_nuc^2 * sum(Ht.^2   ) * dt;

end

% XPS
xps.n        = n_vols;
xps.bt       = bt;
xps.b        = sum(xps.bt(:,1:3), 2);
xps.b_shape  = fwf_1x6_to_shape(xps.bt);
xps.b_rank   = fwf_1x6_to_rank (xps.bt);

xps.mt       = mt;
xps.m        = sum(xps.mt(:,1:3), 2);
xps.m_shape  = fwf_1x6_to_shape(xps.mt);
xps.m_rank   = fwf_1x6_to_rank (xps.mt);

xps.bm_shape = fwf_1x6_to_shape(xps.bt, xps.mt);

xps.gamma    = gamma/3; % Using Arthur convention

xps.gMom_0   = gMom_0;
xps.gMom_1   = gMom_1;
xps.gMom_2   = gMom_2;
xps.gMom_3   = gMom_3;

xps.gMaxXYZ  = gMaxXYZ;
xps.sMaxXYZ  = sMaxXYZ;
xps.gMaxNrm  = gMaxNrm;
xps.sMaxNrm  = sMaxNrm;

xps.cts      = cts;
xps.bgs      = bgs;

% Experimental
% try
%     [a_ind, wf_ind] = resQ_xps2paind(xps);
%     xps.a_ind = a_ind;
%     xps.wf_ind = wf_ind;
% catch me
%     warning(me.message)
% end

% Some legacy stuff
tmp          = tm_1x6_to_tpars(bt);
xps.b_delta  = tmp.delta;
tmp          = tm_1x6_to_tpars(mt);
xps.m_delta  = tmp.delta;

