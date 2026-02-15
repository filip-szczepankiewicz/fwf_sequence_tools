function h = wf3d(wf, col, bound)
% function h = fwf.plot.wf3d(wf, col, bound)

if nargin < 2
    col = [0 0 0];
end

if nargin < 3
    bound = 0;
end

alpha = 0.05;

% Plot ghost points to ensure same plot scale regardless of waveform
mv = max(abs(wf(:)))*1.05;
plot3(mv*[-1 1 -1 1], mv*[-1 -1 1 -1], mv*[1 1 -1 -1], 'color', 'none'); hold on



if all(size(col) == [1 3])
    h = plot3(wf(:,1), wf(:,2), wf(:,3), 'color', col);
else
    for i = 2:size(wf, 1)
        ind = [i-1 i];
        h(i) = plot3(wf(ind,1), wf(ind,2), wf(ind,3), 'color', col(i,:));
    end
end

switch bound
    case 0

    case 1
        s = max(my_norm(wf,2))*1.02;
        plot_sphere(s, alpha);
    case 2
        s = max(abs(wf(:)))*1.02;
        plot_cube(s, alpha);
end

if bound < 2
    s = max(vecnorm(wf, 2, 2))*0.08;
else
    s = max(abs(wf(:)))*0.08;
end

hs = plot_sphere(s, .2);
set(hs, 'facecolor', [.8 .2 .2]);


axis equal
axis vis3d
light('position', [1 0 1])
camlight(10,10)

set(gca, 'YTickLabel', [], 'XTickLabel', [], 'ZTickLabel', [], 'GridLineStyle' , ':')

end


function h = plot_sphere(s, alpha)

[x,y,z] = ellipsoid(0,0,0,s,s,s,200);
h = patch(surf2patch(x,y,z, 'k'));
set(h,'edgecolor','none','linewidth', 0.1, 'facealpha', alpha)

end


function h = plot_cube(s, alpha)

x=[0 1 1 0 0 0;1 1 0 0 1 1;1 1 0 0 1 1;0 1 1 0 0 0]*s*2-s;
y=[0 0 1 1 0 0;0 1 1 0 0 0;0 1 1 0 1 1;0 0 1 1 1 1]*s*2-s;
z=[0 0 0 0 0 1;0 0 0 0 0 1;1 1 1 1 0 1;1 1 1 1 0 1]*s*2-s;

for i=1:6
    h=patch(x(:,i),y(:,i),z(:,i),[1 1 1]*0.5);
    set(h,'edgecolor','w','linewidth', 0.1, 'facealpha', alpha)
end
end

