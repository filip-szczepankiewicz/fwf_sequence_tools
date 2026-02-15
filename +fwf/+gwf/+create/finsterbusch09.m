function [gwf, rf, dt] = finsterbusch09(gamp, slew, dt, t1, t2, tp, u)
% function [gwf, rf, dt] = fwf.gwf.create.finsterbusch09(gamp, slew, dt, t1, t2, tp, u)
%
% Eddy-Current Compensated DW with a Single Refocusing RF
% J. Finsterbusch
% https://onlinelibrary.wiley.com/doi/epdf/10.1002/mrm.21899
%
% This function is incomplete!

if nargin < 1
    gamp = 80e-3;
    slew = 30;
    dt   = .1e-3;
    t1   = 40e-3;
    t2   = 39e-3;
    tp   = 8e-3;
    u    = [1 0 0];

    [gwf, rf, dt] = fwf.gwf.create.finsterbusch09(gamp, slew, dt, t1, t2, tp, u);

    clf
    fwf.plot.wf2d(gwf, rf, dt);
    return
end

ru = fwf.gwf.create.ramp(gamp, slew, dt);
rd = flip(ru);

nr = numel(ru);
tr = nr * dt;

ta   = (t2+t1-3*tr)/2-tr; % Duration of first pulse (only flat top time)
tb   = (t1-t2-tr)/2-tr;   % Duration of second pulse
% tc   = ta-tb-tr;        % Duration of third pulse (defined from others to keep perfect balance)

na = floor(ta/dt);
nb = floor(tb/dt);
nc = na-nb-nr;
np = round(tp/dt);

gwf = [ru  ones(1, na)*gamp rd -ru -ones(1, nb)*gamp -rd zeros(1, np) ru ones(1, nc)*gamp rd];

rf  = ones(length(gwf),1);
rf((4*nr + na + nb + round(np/2)):end) = -1;

gwf = gwf' * u;


