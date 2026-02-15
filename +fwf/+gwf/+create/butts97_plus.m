function [gwf, rf, dt] = butts97_plus(g, s, d, dp, dt)
% function [gwf, rf, dt] = fwf.gwf.create.butts97_plus(g, s, d, dp, dt)
%
% Butts et al. (1997)
% MRM 3&741-749 (1997)
% PMID: 9358448
% DOI: 10.1002/mrm.1910380510
% 
% Note that this design was later used by Moffat et al. 2004 without
% citation?
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d  is the duration of the pulse group in s
% dp is the duration of the pause in s
% dt is the time step size in s
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 25e-3;
    dp = 8e-3;
    dt = 0.1e-3;

    clf
    [gwf, rf, dt] = fwf.gwf.create.butts97_plus(g, s, d, dp, dt);
    fwf.plot.wf2d(gwf, rf, dt);
    return
end

periods = ...
    {[0 1/4 1/2 3/4 1]
     [0 1/4 1/2 3/4 1]
     [0 1/4 1/2 3/4 1]};

signs = {[-1 1 1 1], [-1 -1 1 1], [1 1 -1 -1]};

wf{1} = [];
wf{2} = [];
wf{3} = [];

for i = 1:3
    zp = periods{i};
    zs = signs{i};
    
    for j = 2:numel(zp)
        tenc = (zp(j)-zp(j-1))*d;
        
        n = round(tenc/dt);

        trap_wf = fwf.gwf.create.trapezoid(g, s, dt, n);
        
        wf{i} = [wf{i} trap_wf(1:(end-1)) * zs(j-1)];
    end
end

g1  = [ [wf{1} 0]; [wf{2} 0]; [wf{3} 0]];
g2  = [flip([wf{1} 0]); flip([wf{2} 0]); -flip([wf{3} 0])];
gz  = zeros(3, round(dp/dt));
gwf = [g1 gz g2]';

rf  = ones(size(gwf,1),1);
rf(round(size(rf,1)/2):end) = -1;

[gwf, rf, dt] = fwf.gwf.force.shape(gwf, rf, dt, 'STE');
 
if sum(abs(sum(gwf.*rf))) > 0.0001
    error('not balanced')
end



