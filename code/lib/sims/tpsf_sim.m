function tpsf = tpsf_sim(t, muA, muSp, rho, n)

v = 3e11 / n; %speed of light in medium (mm/sec)
D = v/(3*muSp);

% tpsf = t.^(-5/2) .* exp(-v*muA*t) .* exp( -rho^2./(4*D*t) );

R      = -1.440./n^2+0.710/n+0.668+0.0636*n; % Effective reflection coefficient
ze     = 2/3*(1+R)/(1-R); % Extrapolated boundary is given by ze divided by musp
r1     = sqrt( rho^2 + 1/muSp^2 );
r2     = sqrt( rho^2 + (1+2*ze)^2/muSp^2 );
tpsf = t.^(-3/2) .* exp(-v*muA*t) .* (exp( -r1^2./(4*D*t) ) - exp( -r2^2./(4*D*t) ) );
