function [gwf, rf, dt, x] = fwf_gwf_create_dde_optStim(g, s_o, s_i, d, tp, dt, hw, ns_thr, u1, u2, btarg)
% function [gwf, rf, dt, x] = fwf_gwf_create_dde_optStim(g, s_o, s_i, d, tp, dt, hw, ns_thr, u1, u2, btarg)
% Filip Sz, Lund University
%
% g   is the maximal gradient amplitude in T/m
% s_o is the maximal outer slew rate in T/m/s
% s_i is the maximal inner slew rate in T/m/s
% d   is the maximal duration of the pulse pairs in s
% dp  is the duration of the pause in s
% dt  is the time step size in s
% uX  is the direction of pulse pairs, 1x3 unit vectors
% hw  is the safe-model hardware specification structure as defined in:
% github.com/filip-szczepankiewicz/safe_pns_prediction
% ns_thr is the nerve stimualtion threshold in percent
% btarg  is the target b-value in s/m2
%
% Note 1: the stimulation depends on gwf rotation so optimize for the
% worst-case scenario!
% Note 2: the optimizer often finds local minima, so run it a few
% times to see if a better result exists!

if nargin < 1
    gmax  = 0.2; % T/m
    smax  = 200; % T/m/s
    dmax  = 30e-3; % s
    tp    = 8e-3; % s
    dt    = 1e-4; % s
    nsmax = 95; % %
    u     = [0 0 1]; % unit vector
    btarg = 0.5e9; % s/m2
    hw    = safe_hw_cimaX_cardiac;

    [gwf, rf, dt, x] = fwf_gwf_create_dde_optStim(gmax, smax, smax, dmax, tp, dt, hw, nsmax, u, u, btarg);
    pns = safe_gwf_to_pns(gwf, rf, dt, hw, 1);

    bout = fwf_gwf_to_bval(gwf, rf, dt);

    clf
    subplot(2,2,1)
    fwf_gwf_plot_wf2d(gwf, rf, dt)
    title(['b=' num2str(bout/1e9,2) ' ms/µm^2 for durPulse=' num2str(x(4)*1e3) ' ms'])

    subplot(2,2,2)
    safe_plot(pns, dt)

    subplot(2,2,3)
    sl = [diff(gwf, 1,1)/dt; 0 0 0];
    fwf_gwf_plot_wf2d(sl/1000, rf, dt)
    title(['Slew rate outer=' num2str(x(2),'%0.0f') ' inner=' num2str(x(3),'%0.0f') ' [T/m/s]'])
    ylabel('Slew rate [T/m/s]')
    return
end

glim  = g;
slim  = max([s_o s_i]);

% weighted cost
%        dur  ns  slew  gamp   bval
wght  = [1e4  10    1     1     1e-6]';

fh = @(x)this_fun(x);

%     gamp  so   si   dur
lb = [10e-3 30   30   5e-3];
ub = [g     s_o  s_i  d   ];

% Optimize
opt = optimoptions('particleswarm','SwarmSize',1000,'HybridFcn',@fmincon, 'useParallel', logical(1));
x   = particleswarm(fh, 4, lb, ub, opt);

[gwf, rf, dt] = fwf_gwf_create_dde_variSlew(x(1), x(2), x(3), x(4), tp, dt, u1, u2);

    function cost = this_fun(x)
            [gwf, rf, dt] = fwf_gwf_create_dde_variSlew(x(1), x(2), x(3), x(4),  tp, dt, u1, u2);

            gmax  = max(vecnorm(gwf,2,2));
            smax  = max(max(diff(gwf,1,1)/dt));
            bcurr = fwf_gwf_to_bval(gwf, rf, dt);
            pns   = safe_gwf_to_pns(gwf, rf, dt, hw, 1);
            mpns  = max(pns(:));
            dtot  = size(gwf,1)*dt;

            cost  = [dtot  (mpns-ns_thr)*(mpns>ns_thr)  (smax-slim)*(smax>slim)   (gmax-glim)*(gmax>glim)  abs(bcurr-btarg)];
            cost  = cost*wght;
    end

end