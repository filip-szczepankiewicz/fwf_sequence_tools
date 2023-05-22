function [gwf_out, rf_out, dt_out] = fwf_gwf_interp_slew(gwf, rf, dt, n_samp, method)
% function [gwf_out, rf_out, dt_out] = fwf_gwf_interp_slew(gwf, rf, dt, n_samp, method)

warning('This function does not return balanced waveforms ans should be used with caution!')

if nargin < 2
    rf = [];
end

if nargin < 3
    dt = [];
end

if nargin < 5
    method = 'linear';
end

if any(size(gwf)<3)
    error('Input gwf size must be nx3!')
end


s = diff(gwf, 1)/dt;

% Set sampling grid
x = 1:size(s,1);
q = linspace(min(x), max(x), n_samp);

% Resample gwf
s_out = interp1(x, s, q, method);

% Scale dt, assuming constant total time
% Note that this is not exactly how it works on the scanner.
ttot = dt*(size(gwf,1)-1);
dt_out = ttot / size(s_out,1);

gwf_out = cumtrapz(s_out,1)*dt_out;

if ~isempty(rf)
    % Resampe rf and set proper sign values
    x = 1:size(rf,1);
    q = linspace(min(x), max(x), n_samp);
    rf_out  = interp1(x,  rf(:), q, method)';
    rf_out(rf_out > 0) =  1;
    rf_out(rf_out < 0) = -1;
else
    rf_out = [];
end


