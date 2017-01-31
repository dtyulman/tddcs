params.muA = .0051;  %1/mm
params.muSp = .567; %1/mm
params.n = 1.34; 
params.rho = 5; % mm
params.lambda = 760e-6; %mm
params.Db = 1.09e-8; % 1/cm
params.pulseWidth = 50e-12; %sec
tmin = 0;
tmax = 1.1e-8;
taus = [0, logspace(-7, 0, 100)];

figure;
dt = 10e-12;
t = dt:dt:tmax;
tpsf = tpsf_sim(t, params.muA, params.muSp, params.rho, params.n);
semilogy( t, tpsf/trapz(t, tpsf) )
title('TPSF')
ylabel('# of photons')
xlabel('Time of flight (secs)')


[g2, taus] = g2sim(params, taus, tmin, tmax);
g2 = (g2-1)/2+1; %correct for unpolarized light
figure;
semilogx(taus, g2);
title('Simulated autocorrelation function')
xlabel('\tau (sec)')
ylabel('g_2(\tau)')





