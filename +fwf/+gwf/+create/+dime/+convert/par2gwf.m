function [gwf, t] = par2gwf(x, dur, tp)
% function [gwf, t] = dime.convert.par2gwf(x, dur, tp)
% By Filip Szczepankiewicz, Lund University
% 
% Convert optimization parameters (control points) to gradient levels and
% corresponding times.

alpha       = x(1); % Fractional amplitude of xy gradient compared to z
beta        = x(2); % Fraction of flat top time dedicated to xy gradients
rampUpXY    = x(3); % Ramp up time for xy-gradient
rampDownXY  = x(4); % Ramp down time for xy-gradient
rampUpZ     = x(5); % Ramp up time for z-gradient
rampDownZ   = x(6); % Ramp down time for z-gradient
gampGlo     = x(7); % Global amplitude scale

%Total waveform duration
ttot = 2*dur + tp;

%Compute total free flat time based on XY  and Z ramp durations
ftt = dur - (2*(rampUpXY + rampDownXY) + (rampUpZ + rampDownZ));

%Split flat time between XY and Z
fttx = ftt * beta;
fttz = ftt * (1 - beta);

%Time shifts for each axis
tsx = 0;
tsy = dur + tp + rampUpZ + rampDownZ + fttz;
tsz = 2*(rampUpXY + rampDownXY) + fttx;

%Generate gradient waveforms for X, Y, Z
[gx, tx] = this_pts2wf(rampUpXY, rampDownXY, fttx/2,  0, tsx, ttot);
[gy, ty] = this_pts2wf(rampUpXY, rampDownXY, fttx/2,  0, tsy, ttot);
[gz, tz] = this_pts2wf(rampUpZ , rampDownZ ,   fttz, tp, tsz, ttot);

gwf = [gx' gy' gz'] .* [alpha alpha 1] * gampGlo;
t   = [tx' ty' tz'];

    function [g, tout] = this_pts2wf(rup, rdown, ftt_local, tp_local, tstart, ttot_local)
        tout = [0 cumsum([tstart rup ftt_local rdown tp_local rdown ftt_local rup]) ttot_local];
        g    = [0 0 1 1 0  0 -1 -1 0 0];
    end
end