function g2 = dcs_fn(params, tau, muA, muSp, rho, wavelength, tau0)
% Inputs:
%  tau: lags (sec)
%  mu_a: absorpion coefficient (cm-1)
%  mu_s: reduced scattering coefficient (cm-1)
%  rho: source-detector separation (cm)
%  wavelength (nm)

beta = params(1);
BFi = params(2);

C1 = 3*muSp*muA;
z0 = 1/(muSp + muA);
zb = 1.76/muSp;
k0 = (1.37*2*pi)/(wavelength*10^-7);
r1 = sqrt(rho^2 + z0^2);
r2 = sqrt(rho^2 + (z0 + 2*zb)^2 );
C3 = 6*muSp^2*k0^2*BFi; % <- want to estimate BFi

if ~exist('tau0', 'var')
    tau0 = tau(1);
end

A = exp(-r1*sqrt(C1 + C3*tau))/r1;
B = exp(-r2*sqrt(C1 + C3*tau))/r2;
C = exp(-r1*sqrt(C1 + C3*tau0))/r1;
D = exp(-r2*sqrt(C1 + C3*tau0))/r2;

g1 = (A - B) / (C - D);
g2 = 1 + beta*g1.^2; % <- want to estimate beta
