function [gwf_out, rf_out, dt_out] = toInterpolated(gwf, rf, dt, n_samp, method)
% function [gwf_out, rf_out, dt_out] = fwf.gwf.toInterpolated(gwf, rf, dt, n_samp, method)

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

% Set sampling grid
x = 1:size(gwf,1);
q = linspace(min(x), max(x), n_samp);

% Resample gwf
gwf_out = interp1(x, gwf, q, method);

if ~isempty(rf)
    % Resampe rf and set proper sign values
    rf_out  = interp1(x,  rf(:), q, method)';
    rf_out(rf_out > 0) =  1;
    rf_out(rf_out < 0) = -1;
else
    rf_out = [];
end

if ~isempty(dt)
    % Scale dt, assuming constant total time
    % Note that this is not exactly how it works on the scanner.
    ttot = dt*(size(gwf,1)-1);
    dt_out = ttot / size(gwf_out,1);
else
    dt_out = [];
end
