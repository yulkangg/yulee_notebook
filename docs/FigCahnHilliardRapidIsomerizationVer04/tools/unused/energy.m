function mu = energy(phip,phis,param)
if param.method
    mu = energy1(phip,phis,param);
else
    mu = energy0(phip,phis,param);
end
end

function mu = energy0(phip,phis,param)
phix = 1-phis-phip;
mu = phis.*mylog(phis)+phip.*mylog(phip)+phix.*mylog(phix) ...
    + param.chipp*phip.^2 + param.chips*phip.*phis + param.chipx*phip.*phix ...
    + param.chiss*phis.^2 + param.chisx*phis.*phix + param.chixx*phix.^2 ...
    + param.chipsx*phip.*phis.*phix;
mu = real(mu);
end

function mu = energy1(phip,phis,param)
psibar = psi_bar_fn(phip,phis,param);
phix = 1-phis-phip;
psibars = phis-psibar/3;
psibarp = phip-2*psibar/3;
mu = psibars.*mylog(psibars)+psibarp.*mylog(psibarp)+psibar/3.*mylog(psibar)+ ...
    phix.*mylog(phix)+psibar/3.*(mylog(param.k0)+2)-param.chi*psibar.^2;
mu = real(mu);
end