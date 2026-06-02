% DOUBLE_WELL_POTENTIAL_ISOMERIZATION 
% 
% Plot potential function f(φ) for the isomerization reaction A <-> B
% using various values of the equilibrium constant K = ψB / ψA
%

clear; clc; close all;

% Set default graphics properties
set(groot, 'defaultAxesFontSize', 20);
set(groot, 'defaultLineLineWidth', 2);
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

% Remove old figure file
system('rm -f *png');

% Prepare figure and domain
figure;
phi = linspace(0, 1, 1000);
K_list = logspace(0, 3, 4);  % K = 1, 10, 100, 1000

legendEntries = {};

for i = 1:length(K_list)
    K = K_list(i);

    % Compute concentrations of A and B
    psiA = phi / (1 + K);
    psiB = phi * K / (1 + K);

    % Compute free energy function
    f = psiA .* log(psiA) + psiB .* log(psiB) + (1 - phi) .* log(1 - phi);
    strf = "$f(\phi) = \psi_A \log \psi_A + \psi_B \log \psi_B + (1-\phi) \log (1-\phi)$";

    % Plot the function
    plot(phi, f, 'DisplayName', sprintf('$K = %g$', K));
    hold on;
end

% Final plot decorations
xlabel('$\phi$');
ylabel('$f$', 'Rotation', 0);
title(strf);
subtitle('Range over $K = \psi_B / \psi_A$, $K \sim 1/K$');
grid on;
legend('Location', 'best');
xlim([0 1]);

% Save figure
print('FigDoubleWellPotentialIsomerization.png', '-dpng');

return


