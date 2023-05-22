function [gwf, rf, dt] = fwf_gwf_create_ogse(g, s, d, dp, dt, np)
% function [gwf, rf, dt] = fwf_gwf_create_ogse(g, s, d, dp, dt, np)

if nargin < 1
    g  = 80e-3;
    s  = 100;
    d  = 40e-3;
    dp = 8e-3;
    dt = .1e-3;
    np = 7;
    
    [gwf, rf, dt] = fwf_gwf_create_ogse(g, s, d, dp, dt, np);
    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end

nmax = floor(d/dt);

nrampmax = floor(nmax/(2*np));

ramp = fwf_gwf_create_ramp_constrained(g, s, dt, nrampmax);

tval = max(ramp);

rampu = ramp(2:(end-1));
rampd = flip(rampu);

nru   = numel(rampu);
nrd   = numel(rampd);

nruft = (nmax - np*nrd)/(np-1);

ntop = floor((nruft-nru) / 2)*2;


traphalf = [rampu tval*ones(1,ntop/2-nru) rampd];
trapfull = [rampu tval*ones(1,ntop/1-nru) rampd];


trpfull = [0];

for i = 1:np
    
    if i == 1 || i == np
        trp = traphalf;
    else
        trp = trapfull;
    end
    
    trpfull = [trpfull 0 trp*(-1)^i];
    
end

trpfull = [trpfull 0]' * [1 0 0];

gz  = zeros(round(dp/dt), 3);
gwf = [trpfull; gz; -trpfull];

rf  = ones(size(gwf, 1), 1);
mid = round(size(trpfull, 1) + size(gz,1)/2);
rf(mid:end) = -1;