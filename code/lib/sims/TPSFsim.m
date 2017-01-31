function tpsf = tpsf_sim(t, muA, muSp, rho, n)

v = 3e11 / n; %speed of light in medium (mm/sec)
D = v/(3*muSp);

tpsf = t.^(-5/2) .* exp(-v*muA*t) .* exp( -rho^2./(4*D*t) );