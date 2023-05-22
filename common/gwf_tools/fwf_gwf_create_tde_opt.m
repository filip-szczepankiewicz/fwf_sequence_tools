function [gwf, rf, dt] = fwf_gwf_create_tde_opt(g, s, d, dp, dt)
% function [gwf, rf, dt] = fwf_gwf_create_tde_opt(g, s, d, dp, dt)
% 
% Returns a time-optimized (minimal duration for high b-val) TDE.
% Ref to Szczepankiewicz et al. DOI: 10.1016/j.jneumeth.2020.109007

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 22.7e-3;
    dp = (8+6)*1e-3;
    dt = 0.05e-3;
    
    [gwf, rf, dt] = fwf_gwf_create_tde_opt(g, s, d, dp, dt);

    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end

u1 = [1 0 0];
u2 = [0 0 1];
u3 = [0 1 0];

steps = 50;

fl = linspace(0.1, 0.9, steps);

% LESS GRANULAR
for i = 1:steps
    f = fl(i);
    [gwf, rf] = get_wf(f);
    b(i) = fwf_gwf_to_bval(gwf, rf, dt);
end

[~, imax] = max(b);

lb = max([fl(imax)-0.1 0.01]);
ub = min([fl(imax)+0.1 0.99]);

fl = linspace(lb, ub, steps);


% MORE GRANULAR
for i = 1:numel(fl)
    f = fl(i);
    [gwf, rf] = get_wf(f);
    b(i) = fwf_gwf_to_bval(gwf, rf, dt);
end


% FINAL
[~, imax] = max(b);
[gwf, rf] = get_wf(fl(imax));

    
    function [gwf, rf] = get_wf(f)
        
        n = round(d/dt*f);
        
        trp = fwf_gwf_create_trapezoid(g, s, dt, n);
        bip = [trp -trp 0];
        
        n = round(d/dt*(1-f));
        
        trp = [fwf_gwf_create_trapezoid(g, s, dt, n) 0];
        
        wfz = zeros(1, round(dp/dt));
        
        gwf = [
            bip'*u1;
            trp'*u2;
            wfz'*[1 1 1];
            trp'*u2;
            bip'*u3;
            ];
        
        rf = [ones(size(bip, 2), 1); ones(size(trp,2),1); wfz'; -ones(size(bip, 2), 1); -ones(size(trp,2),1)];
        
        [gwf, rf, dt] = fwf_gwf_force_shape(gwf, rf, dt, 'ste');
    end

end

