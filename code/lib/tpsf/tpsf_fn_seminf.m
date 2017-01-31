function tpsf = tpsf_fn_seminf(muA, muSp, A, t0, t, rho)
% muA: absorption coeff
% muSp: scattering coeff
% A: amplitude scaling factor
% t0: time offset (nanoseconds)
% t: time of flight (nanoseconds)
% rho: source-detector separation (cm)

c = 3e10; %speed of light (cm/s)
n = 1.333; %index of refraction

v = c/n;
D = v/(3*muSp);

t = t - t0;
t = t*1e-9; %convert to seconds 

A = A*1e-18;

tpsf = real(A*t.^(-5/2) .* exp(-v*muA*t) .* exp(-rho^2./(4*D*t)));