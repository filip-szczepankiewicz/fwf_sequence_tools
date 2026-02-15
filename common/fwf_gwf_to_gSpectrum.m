function [p, f] = fwf_gwf_to_gSpectrum(gwf, rf, dt, n_pad)
% function [p, f] = fwf_gwf_to_gSpectrum(gwf, rf, dt, n_pad)
%
% Inspired by gwf_power_spectrum(tmp, rf, dt) but sped up by a factor 7-10,
% mainly due to the (generally) reduced padding.
%
% p is the power spectrum of the gradient vector
% f is the frequency vector

if nargin < 4 || isempty(n_pad)
    n_pad = ceil(2*pi*size(gwf,1));
end

q = gwf;

q = [zeros(n_pad, size(q,2)); ...
    q; ...
    zeros(n_pad, size(q,2)) ];

p = zeros(size(q,1), 3);
f = linspace(-1/dt/2, 1/dt/2, size(p,1));

for i = 1:3
    if any(q(:,i))
        tmp = fft(q(:,i) * dt, [], 1);
        p(:,i) = abs(fftshift( tmp )).^2;
    end
end
