function u_pad = pcolor_pad(u)
% Add an extra row and column to phi
u_pad = [u, u(:,end); u(end,:), u(end,end)];
end
