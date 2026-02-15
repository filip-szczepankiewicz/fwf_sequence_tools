function [p, f] = fwf_gwf_to_qSpectrum(gwf, rf, dt, n_pad)
% function [ps, f] = fwf_gwf_to_qSpectrum(gwf, rf, dt, n_pad)
%
% Inspired by gwf_power_spectrum(tmp, rf, dt) but sped up by a factor 7-10,
% mainly due to the (generally) reduced padding.
%
% p is the power spectrum of the dephasing vector
% f is the frequency vector

if nargin < 4 || isempty(n_pad)
    n_pad = ceil(2*pi*size(gwf,1));
end

q = fwf_gwf_to_qt(gwf, rf, dt);
q = [zeros(n_pad, size(q,2)); ...
    q; ...
    zeros(n_pad, size(q,2)) ];

p = zeros(size(q,1), 6);
f = linspace(-1/dt/2, 1/dt/2, size(p,1));

if any(q(:,1))
    f1 = fft(q(:,1) * dt, [], 1);
    p(:,1) = fftshift( f1 .* conj( f1 ) ) ;
end

if any(q(:,2))
    f2 = fft(q(:,2) * dt, [], 1);
    c2 = conj( f2 );
    p(:,2) = fftshift( f2 .* c2 ) ;

    if any(q(:,1))
        p(:,4) = fftshift( f1 .* c2 ) * sqrt(2);
    end
end

if any(q(:,3))
    f3 = fft(q(:,3) * dt, [], 1);
    c3 = conj( f3 );
    p(:,3) = fftshift( f3 .* c3 ) ;

    if any(q(:,1))
        p(:,5) = fftshift( f1 .* c3 ) * sqrt(2);
    end

    if any(q(:,2))
        p(:,6) = fftshift( f2 .* c3 ) * sqrt(2) ;
    end
end
