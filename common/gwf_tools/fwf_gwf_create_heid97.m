function [gwf, rf, dt] = fwf_gwf_create_heid97(g, s, d, dp, dt, do_corr_shape)
% function [gwf, rf, dt] = fwf_gwf_create_heid97(g, s, d, dp, dt, do_corr_shape)
%
% This is the Siemns Healthcare "one-scan-trace" waveform, although it is
% slightly modified for shorter TE by moving one lobe form before to after
% the 180 pulse, according to Dhital et al. 2018.
%
% https://www.researchgate.net/profile/Oliver_Heid/publication/
% 308960877_Diffusion_Tensor_Trace_Pulse_Sequences/links/
% 58304cf208aef19cb817cb17/Diffusion-Tensor-Trace-Pulse-Sequences.pdf
%
% g  is the maximal gradient amplitude in T/m
% s  is the slew rate in T/m/s
% d  is the duration of each single trapezoid pulse in s
% dp is the duration of the pause in s
% dt is the time step size in s
% do_corr_shape is a boolean. If true the gwf will be corrected to yield
% spherical b-tensor encoding.
% If no input, create example gwf at approximately b2000 and 80 mT/m.

if nargin < 1
    g = 0.08;
    s = 100;
    d = 3.63e-3;
    dp = 8e-3;
    dt = 0.01e-3;
    do_corr_shape = 1;

    [gwf, rf, dt] = fwf_gwf_create_heid97(g, s, d, dp, dt, do_corr_shape);

    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    return
end

if nargin < 6
    do_corr_shape = 1;
end

n = round(d/dt);
np = round(dp/dt);

sig = [...
    [-1 1 1 -1 -1 -1 -1 -1 1 0  -1 -1 -1 -1 -1 1 1];
    [-1 -1 1 1 -1 1 1 -1 -1  0   1 1 1 -1 -1 -1 -1];
    [-1 -1 -1 -1 1 1 1 1 1   0  -1 1 1 -1 1 1 -1] ];

rfs = [1 1 1 1 1 1 1 1 1 0 -1 -1 -1 -1 -1 -1 -1];

trp = fwf_gwf_create_trapezoid(g, s, dt, n);

gwf = [];
rf  = [];

for i = 1:size(sig, 2)

    if sig(1,i) == 0
        wf = zeros(np,3);
        r = ones(size(wf,1),1)*rfs(i-1);
        r(round(size(r,1)/2):end) = rfs(i+1);
    else
        wf = trp' * sig(:,i)';
        r = ones(size(wf,1),1)*rfs(i);
    end

    gwf = [gwf; wf];
    rf  = [rf; r];
end

% Fix the fact that this sequence isnt really isotropic. To do so we must
% decompose the b-tensor and rotate the waveform and scale the axes.
if do_corr_shape
    gwf = fwf_gwf_force_shape(gwf, rf, dt, 'ste');
end
