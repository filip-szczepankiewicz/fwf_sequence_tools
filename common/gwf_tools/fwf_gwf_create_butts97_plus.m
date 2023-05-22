function [gwf, rf, dt] = fwf_gwf_create_butts97_plus(gamp, slew, Ttot, Tp, dt)
% function [gwf, rf, dt] = fwf_gwf_create_butts97_plus(gamp, slew, Ttot, Tp, dt)
%
% Butts et al. (1997)
% MRM 3&741-749 (1997)
% PMID: 9358448
% DOI: 10.1002/mrm.1910380510
% 
% Note that this design was later used by Moffat et al. 2004 without
% citation?

if nargin < 1
    gwf = 80e-3;
    s = 100;
    d = 25e-3;
    dp = 8e-3;
    dt = 0.1e-3;

    [gwf, rf, dt] = fwf_gwf_create_butts97_plus(gwf, s, d, dp, dt);
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end



z = ...
    {[0 1/4 1/2 3/4 1]
     [0 1/4 1/2 3/4 1]
     [0 1/4 1/2 3/4 1]};


s = {[-1 1 1 1], [-1 -1 1 1], [1 1 -1 -1]};

wf{1} = [];
wf{2} = [];
wf{3} = [];

for i = 1:3
    
    zp = z{i};
    zs = s{i};
    
    for j = 2:numel(zp)
        
        tenc = (zp(j)-zp(j-1))*Ttot;
        
        n = round(tenc/dt);

        trap_wf = fwf_gwf_create_trapezoid(gamp, slew, dt, n);
        
        wf{i} = [wf{i} trap_wf(1:(end-1)) * zs(j-1)];
        
    end

end

g1 = [ [wf{1} 0]; [wf{2} 0]; [wf{3} 0]];

g2 = [flip([wf{1} 0]); flip([wf{2} 0]); -flip([wf{3} 0])];

gwf = [g1 zeros(3, round(Tp/dt)) g2]';

rf = [ones(length(g1),1); zeros(round(Tp/dt),1); -ones(length(g2),1)];

[gwf, rf, dt] = gwf_force_shape(gwf, rf, dt, 'STE');
 
if sum(abs(sum(gwf.*rf))) > 0.0001
    error('not balanced')
end



