function [gwf, R] = fwf_gwf_to_low_freq_x_ch(gwf)
% function [gwf, R] = fwf_gwf_to_low_freq_x_ch(gwf)
% Function rotates input waveform to get the lowest frequency axis along
% the first channel. This function is not suited for general use.

[~,~,R] = eig(gwf'*gwf);

gwf = gwf*R;