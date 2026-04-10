function dirs = dirgen(N, varargin)
% DIRGEN  Optimize N directions on the sphere by electrostatic repulsion.
%
%   dirs = dirgen(N)
%   dirs = dirgen(N, Name, Value, ...)
%
%   Returns an (N x 3) matrix of unit vectors, optimized so that the
%   electrostatic repulsion energy between the directions (and their
%   antipodal counterparts) is minimized.  This replicates the default
%   behaviour of MRtrix3's dirgen command (bipolar model, power = 1).
%
%   Options (Name, Value pairs):
%
%     'unipolar'   false (default) | true
%                  false : bipolar model — each direction u_i interacts with
%                          all u_j AND -u_j. This is the standard DWI case.
%                          Produces directions uniformly covering the full
%                          sphere, but antipodally symmetric (u_i and -u_i
%                          both present in the effective charge distribution).
%                  true  : unipolar model — directions interact only with
%                          each other, not with antipodal images. Useful for
%                          half-sphere applications (e.g. ODF sampling).
%
%     'power'      1 (default) | 2 | 4 | 8 | ...
%                  Exponent p in the repulsion law E ~ 1/r^p.
%                  Higher p makes directions repel more strongly at short
%                  range, giving more evenly distributed sets for large N.
%                  Must be a positive power of 2 to match MRtrix3 behaviour,
%                  but any positive value works in practice.
%
%     'niter'      10000 (default)
%                  Maximum gradient-descent iterations per restart.
%
%     'restarts'   10 (default)
%                  Number of random restarts. The best result (lowest energy)
%                  over all restarts is returned.
%
%     'step'       0.1 (default)
%                  Initial gradient-descent step size (fraction of radian).
%                  Adapted per-restart via backtracking line search.
%
%     'verbose'    false (default) | true
%                  Print energy after each restart.
%
%   Algorithm:
%     Gradient descent with adaptive step size on the product manifold of
%     unit spheres, following the MRtrix3 dirgen implementation (Jones et al.
%     MRM 1999; Tournier et al. NeuroImage 2019).
%
%     The energy is:
%       Bipolar:  E = sum_{i<j} 1/|u_i - u_j|^p + 1/|u_i + u_j|^p
%       Unipolar: E = sum_{i<j} 1/|u_i - u_j|^p
%
%     At each iteration, the gradient of E w.r.t. each u_i is computed,
%     projected onto the tangent plane of the sphere at u_i (to maintain
%     the unit-norm constraint), and a gradient-descent step is taken.
%     Step size halves whenever the energy does not decrease.
%
%   Example:
%     % Standard DWI — 30 directions, bipolar (default)
%     dirs = dirgen(30);
%     figure; scatter3(dirs(:,1), dirs(:,2), dirs(:,3), 60, 'filled');
%     axis equal; title('30 bipolar directions');
%
%     % Unipolar — 30 directions on the half-sphere
%     dirs_uni = dirgen(30, 'unipolar', true);
%
%   See also: Jones DK et al., MRM 42:515-525 (1999).
%             Tournier JD et al., NeuroImage 202:116137 (2019).

% -------------------------------------------------------------------------
% Parse inputs
% -------------------------------------------------------------------------
p = inputParser;
addRequired(p,  'N',          @(x) isscalar(x) && x >= 1 && x == round(x));
addParameter(p, 'unipolar',   false, @islogical);
addParameter(p, 'power',      1,     @(x) isscalar(x) && x > 0);
addParameter(p, 'niter',      10000, @(x) isscalar(x) && x >= 1);
addParameter(p, 'restarts',   10,    @(x) isscalar(x) && x >= 1);
addParameter(p, 'step',       0.1,   @(x) isscalar(x) && x > 0);
addParameter(p, 'verbose',    false, @islogical);
parse(p, N, varargin{:});

unipolar = p.Results.unipolar;
pw       = p.Results.power;
niter    = p.Results.niter;
nrestarts = p.Results.restarts;
step0    = p.Results.step;
verbose  = p.Results.verbose;

% -------------------------------------------------------------------------
% Run restarts, keep best
% -------------------------------------------------------------------------
best_E    = Inf;
best_dirs = [];

for r = 1:nrestarts

    % Random initialisation on unit sphere
    u = randn(N, 3);
    u = u ./ vecnorm(u, 2, 2);   % normalise rows to unit length

    step = step0;
    E_prev = energy(u, pw, unipolar);

    for iter = 1:niter

        % Compute energy gradient w.r.t. each direction
        g = grad_energy(u, pw, unipolar);

        % Project gradient onto tangent plane of sphere at each u_i:
        %   g_tangent = g - (g . u) * u
        gdotu = sum(g .* u, 2);          % (N x 1) dot products
        g_tan = g - gdotu .* u;          % (N x 3) tangent components

        % Gradient norm — used to check convergence
        gnorm = norm(g_tan, 'fro');
        if gnorm < 1e-12
            break
        end

        % Proposed update: move along negative tangent gradient
        u_new = u - step .* g_tan;

        % Project back onto sphere
        u_new = u_new ./ vecnorm(u_new, 2, 2);

        E_new = energy(u_new, pw, unipolar);

        if E_new < E_prev
            % Accept step, try slightly larger step next time
            u      = u_new;
            E_prev = E_new;
            step   = step * 1.05;
        else
            % Reject step, shrink step size (backtracking)
            step = step * 0.5;
            if step < 1e-12
                break
            end
        end
    end

    E_final = energy(u, pw, unipolar);

    if verbose
        fprintf('Restart %d/%d: E = %.6f\n', r, nrestarts, E_final);
    end

    if E_final < best_E
        best_E    = E_final;
        best_dirs = u;
    end
end

dirs = best_dirs;

if verbose
    fprintf('Best energy: %.6f\n', best_E);
    nn_angle = min_neighbour_angle(dirs);
    fprintf('Min nearest-neighbour angle: %.2f deg\n', rad2deg(nn_angle));
end

end % main function


% =========================================================================
% Local functions
% =========================================================================

function E = energy(u, pw, unipolar)
% Compute total electrostatic repulsion energy.
% u : (N x 3) unit vectors
% pw: repulsion exponent
% unipolar: logical

    N = size(u, 1);
    E = 0;

    for i = 1:N-1
        % Differences u_i - u_j for all j > i, vectorised
        du = u(i,:) - u(i+1:end, :);          % ((N-i) x 3)
        r  = vecnorm(du, 2, 2);                % distances
        % Clamp to avoid division by zero (degenerate configs at start)
        r  = max(r, 1e-12);
        E  = E + sum(r .^ (-pw));

        if ~unipolar
            % Add interaction with antipodal images: u_i - (-u_j) = u_i + u_j
            dp = u(i,:) + u(i+1:end, :);
            rp = vecnorm(dp, 2, 2);
            rp = max(rp, 1e-12);
            E  = E + sum(rp .^ (-pw));
        end
    end
end


function g = grad_energy(u, pw, unipolar)
% Compute gradient of energy w.r.t. each row of u.
% Returns g (N x 3), same shape as u.

    N = size(u, 1);
    g = zeros(N, 3);

    for i = 1:N
        % All j ~= i
        j = [1:i-1, i+1:N];

        du = u(i,:) - u(j,:);             % ((N-1) x 3)
        r  = vecnorm(du, 2, 2);           % (N-1) x 1
        r  = max(r, 1e-12);
        % d/du_i [ r^(-pw) ] = -pw * r^(-pw-2) * (u_i - u_j)
        coeff = -pw .* r .^ (-pw - 2);    % (N-1) x 1
        g(i,:) = sum(coeff .* du, 1);

        if ~unipolar
            dp = u(i,:) + u(j,:);         % (u_i - (-u_j))
            rp = vecnorm(dp, 2, 2);
            rp = max(rp, 1e-12);
            coeffp = -pw .* rp .^ (-pw - 2);
            g(i,:) = g(i,:) + sum(coeffp .* dp, 1);
        end
    end
end


function a = min_neighbour_angle(u)
% Return the minimum nearest-neighbour angle (radians) in direction set u.
    N  = size(u, 1);
    a  = pi;
    for i = 1:N
        j = [1:i-1, i+1:N];
        cosines = u(i,:) * u(j,:)';     % dot products (absolute, antipodal symmetry)
        cosines = min(abs(cosines), 1); % clamp numerical noise
        angles  = acos(cosines);
        a = min(a, min(angles));
    end
end
