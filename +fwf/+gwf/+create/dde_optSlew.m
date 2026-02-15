function [gwf, rf, dt, x] = fwf_gwf_create_dde_optSlew(gamp, s_o, s_i, d , tp, dt, hw, ns_thr, u1, u2)
% function [gwf, rf, dt, x] = fwf_gwf_create_dde_optSlew(gamp, s_o, s_i, d , tp, dt, hw, ns_thr, u1, u2)
%
% g  is the maximal gradient amplitude in T/m
% s_o is the outer slew rate in T/m/s
% s_i is the inner slew rate in T/m/s
% d  is the duration of the pulse pairs in s
% dp is the duration of the pause in s
% dt is the time step size in s
% uX is the direction of pulse pairs, 1x3 unit vectors
% hw is the safe-model hardware specification structure as in:
% github.com/filip-szczepankiewicz/safe_pns_prediction
% pns_thr is the nerve stimualtion threshold in percent
%
% Note that the stimulation depends on rotations so optimize for the
% worst-case rotation!

fh = @(x)this_fun(x);
x = particleswarm(fh, 2, [30 30], [s_o s_i]);
[gwf, rf, dt] = fwf_gwf_create_dde_variSlew(gamp, x(1), x(2), d, tp, dt, u1, u2);

    function cost = this_fun(x)
        try
            [gwf, rf, dt] = fwf_gwf_create_dde_variSlew(gamp, x(1), x(2), d, tp, dt, u1, u2);

            % Estimate nerve stimulation by SAFE model:
            % github.com/filip-szczepankiewicz/safe_pns_prediction
            pns = safe_gwf_to_pns(gwf, rf, dt, hw, 1);
            pns = max(pns(:));
            b = fwf_gwf_to_bval(gwf, rf,dt);
            cost = 1/b*1e-9 + (pns-ns_thr)*(pns>ns_thr);

        catch me
            cost = 1000;
        end
    end

end