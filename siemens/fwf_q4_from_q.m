function q4 = fwf_q4_from_q(q, dt)
% function q4 = fwf_q4_from_q(q,dt)
% returns discrete autocorrelation function of q^2
% By Arthur Chakwizira
% Lund University, Sweden

q4 = fftshift(ifft(fft(q.^2)*dt.*conj(fft(q.^2)*dt)))/dt;

end