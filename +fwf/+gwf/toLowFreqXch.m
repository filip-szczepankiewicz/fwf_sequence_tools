function [gwf, R] = toLowFreqXch(gwf)
% function [gwf, R] = fwf.gwf.toLowFreqXch(gwf)
% Function rotates input waveform to get the lowest frequency axis along
% the first channel. This function is not suited for general use.

[~,~,R] = eig(gwf'*gwf);

gwf = gwf*R;