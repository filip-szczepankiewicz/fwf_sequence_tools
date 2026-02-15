function gwf_out = toInterpolated_matlab(gwf, n_samp)
% function gwf_out = fwf.gwf.toInterpolated_matlab(gwf, n_samp)
% By Filip Szczepankiewicz
% Brigham and Women's Hospital, Harvard Medical School, Boston, MA, USA
% Lund University, Lund, Sweden

if any(size(gwf)<3)
    error('Input gwf size must be nx3!')
end

% Set sampling grid
x = 1:size(gwf,1);
q = linspace(min(x), max(x), n_samp);

% Resample gwf
gwf_out = interp1(x, gwf, q, 'linear');
