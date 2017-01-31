function [beta, BFi] = dcs_fit(acorrdata, tau, muA, muSp, rho, wavlen, minTau, maxTau, plotName)
% Returns the beta and BFi values that provide the best fit of the DCS fit
% function to the measured autocorrelation data
%
% Inputs:
%  acorrdata: measured autocorrelation data
%  tau: lags for the autocorrelation data
%  muA: absorpion coefficient (cm-1)
%  muSp: reduced scattering coefficient (cm-1)
%  rho: source-detector separation (cm)
%  wavlen: wavelength (nm)



if nargin > 6 && exist('minTau', 'var') && exist('maxTau', 'var')
    [acorrdataFit, tauFit] = get_relevant_acorr_section(acorrdata, tau, minTau, maxTau);
    piece = true;
else
    [acorrdataFit, tauFit] = deal(acorrdata, tau);
end


init = [0.25, 1e-9]; %initial guess: [beta, BFi]
options = optimoptions(@lsqcurvefit, ...
                       'Algorithm', 'levenberg-marquardt',...
                       'Display', 'off', ...
                       'ScaleProblem', 'jacobian');

%TODO: pre-multiply weights?
fittedparams = lsqcurvefit(@(params, tau)dcs_fn(params, tau, muA, muSp, rho, wavlen), ...
                           init, tauFit, acorrdataFit, [], [], options);
beta = fittedparams(1);
BFi = fittedparams(2);

if exist('plotName', 'var')
    figure;
    dcs_fit_plot(acorrdata, tau, beta, BFi, muA, muSp, rho, wavlen, plotName, minTau, maxTau)
end







