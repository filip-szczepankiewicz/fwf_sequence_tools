function [gwf, rf, dt] = fwf_gwf_force_dur(gwf, rf, dt, dur)
% function [gwf, rf, dt] = fwf_gwf_force_dur(gwf, rf, dt, dur)
% By FSz
%
% Function forces a total duration of the gradient waveform (including
% padding by zeros) without rescaling the input (just padding).

ntot = ceil(dur/dt);

if size(gwf,1)>=ntot
    return
end


n1 = sum(rf>0);
n2 = sum(rf<0);

n  = round(sum(rf)/2);

p1 = n-n1;
p2 = n-n2;

if p1 < 0
    error()
end
if p2 < 0
    error()
end

gwf = [zeros(p1, 3); gwf];
rf  = [rf(1) * ones(p1,1); rf];

gwf = [gwf; zeros(p2,3)];
rf  = [rf;  rf(end)*ones(p2,1)];


if sum(rf)
    error
end

