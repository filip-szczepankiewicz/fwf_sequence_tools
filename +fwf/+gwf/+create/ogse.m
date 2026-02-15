function [gwf, rf, dt] = fwf_gwf_create_ogse(g, s, d, dp, dt, np)
% function [gwf, rf, dt] = fwf_gwf_create_ogse(g, s, d, dp, dt, np)
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d  is the duration of each encoding period
% dp is the duration of the pause in s
% dt is the time step size in s
% np is the number of pulses per side, inluding half-pulses
% If no input, create example gwf at approximately b2000 and 80 mT/m.

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

nmax = round(d/dt);

nrampmax = round(nmax/(2*np));

ramp = fwf_gwf_create_ramp_constrained(g, s, dt, nrampmax);

tval = max(ramp);

rampu = ramp(2:(end-1));
rampd = flip(rampu);

nru   = numel(rampu);
nrd   = numel(rampd);

nruft = (nmax - np*nrd)/(np-1);

ntop = round((nruft-nru) / 2)*2;


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