% This MATLAB script that simulates the trinary Cahn-Hilliard equation for
% an isomerization reaction A <-> B LLPS, two spatial dimensions, and
% periodic boundary conditions. The simulation employs a pseudo-spectral
% method, where the spatial derivatives are computed using the Fourier
% transform. The result is displayed using a pseudocolor plot

clear; clc; close all;

% --- Paths and setup ---
addpath('./tools/');

% Set default graphics properties
set(groot, 'defaultAxesFontSize', 12);
set(groot, 'defaultLineLineWidth', 2);
set(groot, 'defaultTextInterpreter', 'latex');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
set(groot, 'defaultLegendInterpreter', 'latex');

p.figdir  = './figures/';

make_dir_clobber(p.figdir);

p.make_movie = 1; 
p.snapshots = 0;

p.phi0 = 0.5;
p.chiab = 0;
p.chiax = 1;
p.chibx = 3;
p.k0 = 10; % k0 = association constant k0 = psib/psia

% Other parameters 
p.nxy = 2^7;       % Number of grid points
p.Lxy = 50;       % Domain size
p.dt = 1e-2;      % Time step 1e-3
p.M0 = 1.0;        % Mobility
p.gamma = 1;  % Interfacial width peter
p.total = 100; % Total simulation time

%
% Autonomous from here
%

param_str = sprintf('chi=%2.2f-%2.2f-%2.2f-k0=%2.2f',p.chiab,p.chiax,p.chibx,p.k0);

if 1
    figure;
    phi_vec = linspace(0.001,0.999,200);
    fprime = fder(phi_vec,p);
    f = cumtrapz(phi_vec,fprime);
    subplot(2,1,1)
    plot(phi_vec,fprime);
    ylabel('$f^\prime(\phi)$', 'Rotation', 0);
    title("$f^\prime(\phi)=r_a\log\psi_a+r_b\log\psi_b-\log(1-\phi)+(r_ar_b\chi_{ab}+r_a\chi_{ax}+r_b\chi_{bx})(1-2\phi)$")

    subplot(2,1,2)
    plot(phi_vec,f);
    xlabel('$\phi$');
    ylabel('$f(\phi)$', 'Rotation', 0);
    title("$f(\phi)=\psi_a\log\psi_a+\psi_b\log\psi_b+(1-\phi)\log(1-\phi)+2(\chi_{ab}\psi_{ab}+2\chi_{ax}\psi_a+2\chi_{bx})(1-\phi)$")  
    
    sgtitle({sprintf('Cahn-Hilliard Rapid Isomerization'),param_str});
    movegui(gcf, 'northwest')
    print(sprintf('%s/fig_f_and_fp',p.figdir),'-dpng')
end

nsteps = round(p.total/p.dt); % Number of time steps
nx = p.nxy; ny=p.nxy; 
Lx = p.Lxy; Ly = p.Lxy; 
dx = Lx/nx; dy = Ly/ny; 
x = linspace(0,Lx,nx); y = linspace(0,Ly,ny); 
[X, Y] = meshgrid(x, y);

% Initial conditions
ic_type = 'random';
switch ic_type
    case 'random' % random perturbation around phip/phis
        phi = p.phi0*ones(nx,ny) + 0.1*randn(nx,ny);
        [ psia, psib, phix ] = equil(phi,p);
    otherwise
        error('Unknown method')
end

if p.make_movie
    figure;
    axis tight manual;  % This ensures the axes limits stay fixed
    v = VideoWriter([p.figdir '/cahn-hilliard-movie-' param_str '.mp4'],'MPEG-4');
    open(v);
    modtime = 1; % seconds between saved frames
else
    modtime = 1;
end

% Wave vectors for Fourier space
dkx = (2*pi/Lx); kx = dkx * [0:(nx/2-1), -nx/2:-1];
dky = (2*pi/Ly); ky = dky * [0:(ny/2-1), -ny/2:-1];
[Kx, Ky] = meshgrid(kx, ky);
k2 = Kx.^2 + Ky.^2; % Squared wavenumber
k4 = k2.^2; % Fourth power of wavenumber

% Pseudocolor plot setup
figure;
phi_pad = pcolor_pad(phi); psia_pad = pcolor_pad(psia); psib_pad = pcolor_pad(psib); phix_pad = pcolor_pad(phix);
subplot(2,2,1); h1 = pcolor(phi_pad); %cb1=colorbar('southoutside'); xlabel(cb1,'\phi');
xlabel('$\phi$');
every_subplot();
subplot(2,2,2); h2 = pcolor(phix_pad); %cb2=colorbar('southoutside'); xlabel(cb2,'1-\phi');
xlabel('$1-\phi$');
every_subplot();
subplot(2,2,3); h3 = pcolor(psia_pad); %cb3=colorbar('southoutside'); xlabel(cb3,'\psi_a');
xlabel('$\psi_a$');
every_subplot();
subplot(2,2,4); h4 = pcolor(psib_pad); %cb4=colorbar('southoutside'); xlabel(cb4,'\psi_b');
xlabel('$\psi_b$');
every_subplot();


% Time-stepping loop
for step = 1:nsteps
 
    phi_hat = fft2(phi);
    fprime = fder(phi,p);
    fprime_hat = fft2(fprime);
    phi_hat_new = (phi_hat - p.dt * p.M0 * k2 .* fprime_hat) ./ (1 + p.dt * p.M0 * p.gamma * k4);
    phi = ifft2(phi_hat_new,'symmetric');

    % Periodically display the result 
    if mod(step*p.dt, modtime) == 0

        disp(sprintf("step: %d time: %d",step,p.dt*step))
        [ psia, psib, phix ] = equil(phi,p);
        show(phi,1); show(psia,1); show(psib,1); show(phix,1); disp(' ')

        phi_pad = pcolor_pad(phi); phix_pad = pcolor_pad(phix);
        psia_pad = pcolor_pad(psia); psib_pad = pcolor_pad(psib);

        set(h1, 'CData', phi_pad); set(h2, 'CData', phix_pad);
        set(h3, 'CData', psia_pad); set(h4, 'CData', psib_pad);

        subplot(2,2,1); title(show(phi,0));
        subplot(2,2,2); title(show(phix,0));
        subplot(2,2,3); title(show(psia,0));
        subplot(2,2,4); title(show(psib,0));

        sgtitle({sprintf('Cahn-Hilliard Rapid Isomerization  Time: %.2f', step*p.dt), param_str});
        drawnow;
   
        if p.snapshots
        print(sprintf('%s/fig_%d.png',p.figdir,step*p.dt),'-dpng')
        end

        if p.make_movie
            frame = getframe(gcf);
            writeVideo(v, frame);
        end
    end
end

if p.make_movie
    close(v);
end

figdir_param_str =  ['figures-' param_str];
system(['rm -r ' figdir_param_str ]);
system(['cp -r ' p.figdir ' ' figdir_param_str ]);



function every_subplot()
set(gca, 'color', 'white');
clim([0 1]);
shading flat; axis square; axis equal; axis tight; xticks([]);
yticks([]); box off; % axis off
end

function str = show(phi,verbose)
if verbose
    str = sprintf('%s: %2.6f %2.6f %2.6f',inputname(1),min(phi,[],'all'),mean(phi,'all'),max(phi,[],'all'));
    disp(str)
else
    str = sprintf('%2.6f %2.6f %2.6f',min(phi,[],'all'),mean(phi,'all'),max(phi,[],'all'));
end
end


function fp = fder(phi,p)
[ psia, psib, phix ] = equil(phi,p);
ra = 1/(1+p.k0); rb = 1-ra;
fp = ra*mylog(psia)+rb*mylog(psib)-mylog(phix)+ ...
     (ra*rb*p.chiab + ra*p.chiax + rb*p.chibx)*(1-2*phi);
end

function [ psia, psib, phix ] = equil(phi,p)
phix = 1-phi;
ra = 1/(1+p.k0); rb = 1-ra;
psia = ra*phi;
psib = rb*phi;
end
