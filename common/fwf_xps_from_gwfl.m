function xps = fwf_xps_from_gwfl(gwfl, rfl, dtl, s_ind, wf_ind)
% function xps = fwf_xps_from_gwfl(gwfl, rfl, dtl, s_ind, wf_ind)

n_vols = numel(gwfl);

if nargin < 4
    s_ind = ones(n_vols,1);
end

if nargin < 5
    wf_ind = ones(n_vols,1);
end

bt            = zeros(n_vols, 6);
gamma         = zeros(n_vols, 3);
bVomegaTens   = zeros(n_vols, 6);
bVomega_trace = zeros(n_vols, 1);
bVomega_delta = zeros(n_vols, 1);
gMom_0        = zeros(n_vols, 3);
gMom_1        = zeros(n_vols, 3);
gMom_2        = zeros(n_vols, 3);
gMom_3        = zeros(n_vols, 3);

for i = 1:n_vols

    gwf = gwfl{i};
    rf  = rfl{i};
    dt  = dtl{i};

    bt(i,:) = tm_3x3_to_1x6( fwf_gwf_to_btens(gwf, rf, dt));

    % Exchange weighting
    gamma(i,:) = gwf_to_tex(gwf, rf, dt);

    % Restriction weighting
    [~, tmp] = gwf_to_spectral_moments(gwf, rf, dt);
    pars = tm_3x3_to_tpars(tmp);

    bVomega_trace(i)  = pars.trace;
    bVomega_delta(i)  = pars.delta;
    
    bVomegaTens (i,:) = tm_3x3_to_1x6(tmp);

    % Gradient moments
    gMom_0(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 0, 0);
    gMom_1(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 1, 0);
    gMom_2(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 2, 0);
    gMom_3(i,:) = fwf_gwf_to_motion_enc(gwf, rf, dt, 3, 0);

end

bVomegaTens(isnan(bVomegaTens)) = 0;

xps = mdm_xps_from_bt(bt);

xps.gamma = gamma/3; % Using Arthur convention

xps.VomegaTens   = bVomegaTens./(xps.b+eps);
xps.Vomega_trace = bVomega_trace./(xps.b+eps);
xps.Vomega_delta = bVomega_delta;
xps.gMom_0       = gMom_0;
xps.gMom_1       = gMom_1;
xps.gMom_2       = gMom_2;
xps.gMom_3       = gMom_3;
xps.s_ind        = s_ind;
xps.wf_ind       = wf_ind;





