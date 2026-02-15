function [gwf, rf, dt, ind_se] = epi(g, s, dt, ftt, ms, pf, ipa)
% function [gwf, rf, dt, ind_se] = fwf.gwf.create.epi(g, s, dt, ftt, ms, pf, ipa)
% By FSz
% This function creates an EPI-like gwf, but it should mainly be used for
% PNS calculations and the like since it is not accurate enough to serve
% for actual imaging.
%
% s   - max slew rate in T/m/s
% dt  - time step size in s
% ftt - flat top time in s
% ms  - matrix size (num lines)
% pf  - partial fourier factor
% ipa - in-plane acceleration in phase dir


if nargin < 1
    g = 35e-3;
    s = 200;
    ftt = 1e-3;
    ms = 128;
    pf = 0.75;
    ipa = 2;
    dt = 2e-5;

    [gwf, rf, dt, ind_se] = fwf.gwf.create.epi(g, s, dt, ftt, ms, pf, ipa);
    kt = cumsum(gwf,1)*dt*fwf.util.gammaFromNuc();
    t = fwf.gwf.toTime(gwf, rf, dt);

    clf
    subplot(2,1,1)
    plot(t, gwf)
    hold on
    plot(t(ind_se), 0, 'kx')

    subplot(2,1,2)
    plot(kt(:,1), kt(:,2)); hold on; plot(0, 0, 'kx'); plot(kt(ind_se,1), kt(ind_se,2), 'ko')
    axis equal

    title(kt(ind_se,:))

    return
end


n = ceil(g/s/dt) + round(ftt/dt);
[trp, nramp] = fwf.gwf.create.trapezoid(g, s, dt, n);

tri = fwf.gwf.create.trapezoid(g, s, dt, nramp*2);

kmax = sum(trp)*dt/2;

nl_tot = round(ms/ipa);

nl_after = ceil(nl_tot/2);

nl_before = round(nl_tot*pf)-nl_after;

etl = nl_after + nl_before;

kblip = kmax/(nl_after-1);

blip = tri/(sum(tri)*dt)*kblip;

wf_freq = [];
wf_phas = [];

for i = 0:etl
    if i == 0
        wf_freq = [wf_freq; (-1)^(i)*trp'/2];
    else
        wf_freq = [wf_freq; (-1)^(i)*trp'];
    end
end


for i = 0:(etl-1)
    if i == 0
        wf_phas = [wf_phas; -trp'/2/kmax*nl_before*kblip; zeros(nramp,1)];
    else
        wf_phas = [wf_phas; zeros(numel(trp)-2*nramp,1); blip'];
    end
end

wf_phas = [wf_phas; zeros(numel(trp)-nramp, 1)];


gwf = wf_freq * [1 0 0] + wf_phas * [0 1 0];
rf  = ones(size(wf_freq));

kt = fwf.util.gammaFromNuc()*cumsum(gwf,1)*dt;

[a, ind_se] = min(vecnorm(kt(n:end,:),2,2));

ind_se = ind_se+n-1; % Add one since the search for min excludes first sample.


% Fix small residual moments
% for i = 1:3
%     if kt(ind_se,i)
%         gwf(1:n, i) = gwf(1:n, i) / (gwf_gamma * sum(gwf(1:n, i)) * dt) * (gwf_gamma * sum(gwf(1:n, i)) * dt - kt(ind_se,i));
%     end
% end
