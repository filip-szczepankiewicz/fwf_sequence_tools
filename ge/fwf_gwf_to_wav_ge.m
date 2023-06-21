function [fn_a, fn_b] = fwf_gwf_to_wav_ge(gwf, rf, dt, onam, description)
% function [fn_a, fn_b] = fwf_gwf_to_wav_ge(gwf, rf, dt, onam, description)
% By Filip Sz
% gwfl is a 3D array of gradient waveforms n x 3 x m (n is samples per
% waveform, and m is the number of unique waveforms).

if nargin < 5
    description = 'FWF_LundUni';
end

pind = fwf_gwf_to_partindex(gwf(:,:,1), rf, dt);

A = gwf(pind{1}, :, :);
B = gwf(pind{2}, :, :);

AA = permute(A, [1 3 2]);
BB = permute(B, [1 3 2]);

gmax = max(abs([AA(:); BB(:)]));

% Here we use Tim Schrimers function to save the file in wav format. This
% function is currently not part of the repo and must be acquired from
% Tim/GE.
fn_a = write_ak_wav_Tim([onam '_A.wav'], AA, gmax*100, 125e3, 0.2, description);
fn_b = write_ak_wav_Tim([onam '_B.wav'], BB, gmax*100, 125e3, 0.2, description);

% fn_a = fwf_gwf_write_ge([onam '_A.wav'], AA, gmax, description);
% fn_b = fwf_gwf_write_ge([onam '_B.wav'], BB, gmax, description);


