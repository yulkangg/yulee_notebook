function psi_bar = psi_bar_fn(phi_p,phi_s,param)
phix = 1-phi_s-phi_p;
if phix>0
    psi_bar = fzero(@(x) psi_zero(x,phi_p,phi_s,param),0.01);
else
    psi_bar=0;
end
end

function z = psi_zero(x,phip,phis,param)
phix = 1-phis-phip;
psis = phis-x/3;
psip = phip-2*x/3;
if phix >= 0 && psis>0 && psip> 0
    z = x*param.k0/3-psis.*(psip).^2.*exp(6*param.onoff*param.chi*x);  % The parameterized function.
else
    z = 1e3; % this case needs to be large, real, and not Inf
end
end