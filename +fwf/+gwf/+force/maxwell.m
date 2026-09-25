function [gout, rf, dt, x] = maxwell(gwf, rf, dt, n_pt, m_thr, n_iter, f_bnd)
% function [gout, rf, dt, x] = fwf.gwf.force.maxwell(gwf, rf, dt, n_pt, m_thr, n_iter, f_bnd)
%
% This function corrects/fine-tunes a gradient waveform to restore Maxwell compensation.
%
% Reference:
%       Viktor Olsson, Felix Mortensen, Emil Ljungberg, Frederik Testud, 
%       Ronnie Wirestam, Malwina Molendowska, Filip Szczepankiewicz
%       "Concomitant Gradient Effects Across Field Strengths and Gradient Amplitudes: 
%       Improved Estimation of Errors and Correction of Concomitant 
%       Dephasing and Diffusion Weighting"
%       Magnetic Resonance in Medicine. 2026;96(3):1178-1191.
%       doi:10.1002/mrm.70422
%
%   INPUTS:
%       GWF    - Gradient waveform, N x 3 [T/m]
%       RF     - Spin dephasing direction, N x 1 [1 or -1]
%       DT     - Temporal resolution of the gradient waveform, 1 x 1 [s]
%       N_PT   - Number of triangular perturbation functions per gradient
%                axis. Default: 7.
%       M_THR  - Target Maxwell-index threshold. Default: 100. The
%                threshold is given in the units used by
%                fwf.gwf.toMaxwellInd and is compared after conversion to m^(-2).
%       N_ITER - Number of independent random optimization starts.
%                Default: 32.
%       F_BND  - Maximum absolute amplitude of each triangular perturbation.
%                Default: 0.05, corresponding to +/-5%.
%
%   OUTPUTS:
%       GOUT   - Corrected gradient waveform.
%       RF     - Input RF information, returned unchanged.
%       DT     - Input temporal resolution, returned unchanged.
%       X      - Optimized triangular perturbation coefficients.


if nargin < 4
    n_pt = 7;
end

if nargin < 5
    m_thr = 100;
end

if nargin < 6
    n_iter = 32;
end

if nargin < 7
    f_bnd = 0.05;
end

% get approximate gradient scale to calc fair b-vals
g_nrm = max(vecnorm(gwf, 2, 2));

% Create a triangular waveform with n_pt triangles per axis
fvec = this_createTriangles(n_pt, size(gwf,1));

% Set minimization function and search for a minimum
fun  = @(x)this_cost(x, gwf, rf, dt, fvec);

opt = optimset('fminsearch');
opt.OutputFcn = @this_stopFcn;
opt.MaxFunEvals = 5000;
opt.MaxIter     = 5000;

lb = ones(3, n_pt)*-f_bnd;
ub = ones(3, n_pt)* f_bnd;

% translate to SPMD
parfor i = 1:n_iter
    % Guess is n_pt x 3 zeros
    x0 = lb + rand(3, n_pt) .* (ub-lb);
    x  = fminsearch(fun, x0, opt);

    % Apply optimization and return corrected waveform
    [~, GWF{i}] = fun(x);
    X{i} = x;
end

% Find best solution
for i = 1:n_iter
    tmp = GWF{i};

    % Calc m before fixing waveform to comply with threshold definition
    m(i) = fwf.gwf.toMaxwellInd(gwf, rf, dt)*1e9;

    tmp = fwf.gwf.force.balance_v2(tmp, rf, dt);
    tmp = fwf.gwf.force.shape(tmp, rf, dt, 'ste'); % This is tricky and must be removed
    tmp = tmp/max(vecnorm(tmp, 2, 2))*g_nrm;

    b(i) = fwf.gwf.toBvalue(tmp, rf, dt);
end

% Find the highest b-val that conforms with maxwell threshold
ok_ind = m<=(m_thr*1.01);
[~, min_ind] = min(m);

if sum(ok_ind)
    b_max = max(b(ok_ind));
    ind_final = find(b==b_max);
else
    b_max = max(b(min_ind));
    ind_final = find(b==b_max);
end

gout = GWF{ind_final};
x = X{ind_final};


    function stop = this_stopFcn(~, optimValues, ~)
        stop = optimValues.fval<m_thr;
    end

    function [cost, gwf] = this_cost(f, gwf, rf, dt, fvec)
        gwf  = amc_apply_fvec(gwf, fvec, f);
        gwf  = fwf.gwf.force.balance_v2(gwf, rf, dt);
        cost = fwf.gwf.toMaxwellInd(gwf, rf, dt)*1e9;
    end
end


function f = this_createTriangles(n_pts, n_len)

f = zeros(n_len, n_pts, 3);
w = floor(n_len/n_pts);

p = 1:floor(n_len/n_pts/2):n_len;
p = p(2:2:end);

for j = 1:3
    for i = 1:n_pts
        inda = ceil(p(i)-w/2);
        indb = min([floor(p(i)+w/2) n_len]);

        f(:,i, j) = this_triangularPulse(inda, indb, 1:n_len);
    end
end
end


function triwf = this_triangularPulse(inda, indb, x)

triwf = zeros(size(x));

wid = floor((indb-inda)/2);

int1 = inda:(inda+wid);
int2 = (indb-wid):indb;

triwf(int1) = linspace(0, 1, numel(int1));
triwf(int2) = linspace(1, 0, numel(int2));
end