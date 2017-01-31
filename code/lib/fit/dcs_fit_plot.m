function dcs_fit_plot(acorrdata, tau, beta, BFi, muA, muSp, rho, wavlen, plotName, minTau, maxTau)

semilogx(tau, acorrdata)
hold on
if ~exist('minTau', 'var')
    minTau = tau(1);
end
semilogx(tau, dcs_fn([beta, BFi], tau, muA, muSp, rho, wavlen, minTau))

legendtxt = {'Raw data', 'Fitted curve'};

if exist('minTau', 'var') && exist('maxTau', 'var')
    p = patch([minTau, minTau, maxTau, maxTau], [0, 3, 3, 0], 'g');
    alpha(p, 0.05);
    ylim([0.995, max(max(acorrdata),beta)]);
    legendtxt{end+1} = 'Range over which fit was computed';
end

titlestr = sprintf('%s\n Beta=%f BFi=%g cm^2/s mu_A: %g cm^{-1} muSp: %g cm^{-1}', plotName, beta, BFi, muA, muSp);
title(titlestr);
xlabel('Tau (sec)')
ylabel('Autocorrelation g_2(\tau)')

legend(legendtxt)
semilogx(tau, ones(size(tau)), 'k--')