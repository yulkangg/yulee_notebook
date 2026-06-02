function ternary_plot(X,Y,Z,F,sz,axis_str,title_str)
% Convert (x, y, z) to barycentric coordinates for plotting
% Barycentric coordinates (0,0) = bottom left, (1,0) = bottom right, (0,1) = top
tri_x = 0.5 * (2 * Y + Z); % x-coordinates for plotting
tri_y = sqrt(3) / 2 * Z;          % y-coordinates for plotting

% Plotting in barycentric coordinates
scatter(tri_x, tri_y, sz, F, 'filled'); % Scatter plot with color based on free energy
colormap(parula);
cb=colorbar;
clim([-Inf Inf])
set(cb,'position',[.8 .5 .05 .3])
title(title_str)
ax = gca; ax.TitleHorizontalAlignment = 'left';
axis equal;
axis off;


% Adding triangle boundaries for clarity
hold on;
plot([0, 0.5, 1, 0], [0, sqrt(3)/2, 0, 0], 'k-'); % Triangle boundary
text(-0.05, -0.05, axis_str{1}, 'HorizontalAlignment', 'right');
text(1.05, -0.05, axis_str{2}, 'HorizontalAlignment', 'left');
text(0.5, sqrt(3)/2 + 0.05, axis_str{3}, 'HorizontalAlignment', 'center');
hold off;


end



