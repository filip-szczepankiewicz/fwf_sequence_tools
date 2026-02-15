function [g_o, rf, dt, R, F] = fwf_gwf_force_shape(gwf, rf, dt, shape)
% function [g_o, rf, dt, R, F] = fwf_gwf_force_shape(gwf, rf, dt, shape)
% FSz
% 
% This function forces the shape of the b-tensor according to Eq. 11 in
% Szczepankiewicz et al. https://doi.org/10.1016/j.jneumeth.2020.109007.
% NOTE that the expression before Eq. 11 has a typo; it is missing a square 
% root sign around the eigenvalues!

if nargin < 1
    g = 80e-3;
    s = 100;
    d = 30e-3;
    dp = 10e-3;
    dt = 0.01e-3;
    
    [gwf, rf, dt] = fwf_gwf_create_butts97(g, s, d, dp, dt);
    
    [g_o, rf, dt] = fwf_gwf_force_shape(gwf, rf, dt, 'sym');
    
    figure(1)
    clf
    fwf_gwf_plot_wf2d(gwf, rf, dt);
    
    figure(2)
    clf
    fwf_gwf_plot_wf2d(g_o, rf, dt);
    return
end


% Check balance and warn if poorly balanced
m0 = sum(gwf.*rf*dt,1);

if any(abs(m0)>1e-6)
    warning('The waveform may be poorly balanced which may disrupt shape adjustment!')
end

gmax = max(abs(gwf(:)));
bt_in = fwf.gwf.toBtensor(gwf, rf, dt);


% Calculate rotation matrix to bring waveform into principle axis.
[~, lambda, R] = eig(bt_in, 'vector');


if ischar(shape)
    switch upper(shape)
        case 'LTE'
            shape = lambda' == max(lambda);
        case 'PTE'
            shape = lambda' ~= min(lambda);
        case 'STE'
            shape = [1 1 1];
        case 'SYM'
            % Forces symmetry so that rank 2 -> PTE and rank 3 -> STE
            shape = (lambda'/max(lambda) - 1000*eps) > 0;
    end
end


% Check rank
rin = rank(bt_in);
rout = sum(shape>0);

if rout > rin
    error(['This gradient waveform produces a b-tensor of rank ' num2str(rin)...
        ' which cannot be scaled up to a b-tensor of rank ' num2str(rout) '!'...
        '(Rank out must be <= rank in!)'])
end



% If the gradient waveform is defined as a collumn matrix (3 x n) the
% equation is g' = R' * F * R * g
% But it is reveresed when using MDW format where gwf is (n x 3), so that
% g' = g * R * F * R';

F = diag(sqrt(shape(:)./lambda(:)));

F(isnan(F)) = 0;

g_o = gwf * R * F * R';

% Scale to match original cube
g_o = g_o / max(abs(g_o(:))) * gmax;






