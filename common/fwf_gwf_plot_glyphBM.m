function h = fwf_gwf_plot_glyphBM(gwf, rf, dt, a_par, c_par, c_lim)
% function h = fwf_gwf_plot_glyphBM(gwf, rf, dt, a_par, c_par, c_lim)
%
% a_par is the amplitude parameter (must be in regular xps)
% c_par is the color parameter (must be in regular xps)

if nargin < 4 || isempty(a_par)
    a_par = 'b';
end

if nargin < 5 || isempty(c_par)
    c_par = 'm/b';
end

if nargin < 6 || isempty(c_lim)
    c_lim = [];
end

[u, T] = fix_openCrust_500();

a = zeros(size(u,1), 1);
c = zeros(size(u,1), 1);

for i = 1:size(u,1)
    tmp = gwf*u(i,:)' .* [1 0 0];
    geff = tmp.*rf;

    xps = fwf_xps_from_gwfl({tmp}, {rf}, {dt});

    a(i) = xps.(a_par);

    switch c_par
        case 'm/b'
            c(i) = xps.m / (xps.b+eps);

        case {'sqrt(m/b)', 'sqrt_m/b'}
            c(i) = sqrt(xps.m / (xps.b+eps));

        case 'avg_spec'
            [gwf_ps, f] = fwf_gwf_to_qSpectrum(tmp, rf, dt);
            pdf = gwf_ps(f>=0, 1);
            pdf = pdf/sum(pdf);
            c(i) = pdf' * f(f>=0)';

        case 'rse'
            bia = amc_gwf_to_bias_fast(gwf, rf, dt, u(i,:)*0.15, 5e-3, 3, 0.5, 0);
            c(i) = (1-bia)*100;
            
        otherwise
            c(i) = xps.(c_par);
    end

end


%% PLOT

x = u(:,2).*a(:);   % x-coord
y = u(:,1).*a(:);   % y-coord
z = u(:,3).*a(:);   % z-coord

h = trisurf(T,x,y,z, c,'FaceColor','interp','FaceLighting','phong', 'facealpha', 1);
xlabel('x')
ylabel('y')
zlabel('z')
axis equal

shading interp
axis tight vis3d equal

set(h,'edgecolor','none');
colorbar

if isempty(c_lim)
    cl = [min(c) max(c)];
else
    cl = c_lim;
end

clim(cl)
colormap(gca, fix_cmap_blackredwhite)