function [g, t] = par2gwf(x, dur, tp)
% function [gwf, t] = optDDE.convert.par2gwf(x, dur, tp)
% By Filip Szczepankiewicz, Lund University
% 
% Convert optimization parameters (control points) to gradient levels and
% corresponding times.

rampUp       = x(1); % 
rampDown     = x(2); % 
gampGlo      = x(3); % 

%Compute total free flat time based on XY  and Z ramp durations
ftt = dur/2 - (rampUp + rampDown);

%Generate gradient waveforms for X, Y, Z
% t = [0 cumsum([rampUp ftt rampDown tp rampDown ftt rampUp])]';
% g = [0 1 1 0  0 -1 -1 0]' * gampGlo;

t = cumsum([0 rampUp ftt rampDown rampDown ftt rampUp tp rampUp ftt rampDown rampDown ftt rampUp])';
g = [0 1 1 0 -1 -1 0 0 1 1 0  -1 -1 0]' * gampGlo;