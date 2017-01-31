function [muA, muSp, ampl, t0] = tpsf_fit(tpsfData, tof, rho, init, plotThis)
% Inputs:
%   tpsfData: histogrammed number of photons arriving per tof value
%   tof: time of flight values for associated tpsfData (in nanoseconds)
%   rho: source-detector separation (cm)
%   init: (optional) initial guess [muA, muSp, A, t0]
%
% Returns the values that provide the best fit of the TPSF fit
% function to the measured time of flight data 
%  muA: absorpion coefficient (cm-1)
%  muSp: reduced scattering coefficient (cm-1)


if nargin < 4
    init = [0.04, 5, 1, 1]; %initial guess: [muA, muSp, A, t0]
end

options = optimoptions(@lsqcurvefit, ...
                       'Algorithm', 'levenberg-marquardt', ...
                       'Display', 'off', ... %'iter-detailed' for details
                       'ScaleProblem', 'jacobian'); %default is 'none'
                       
fittedparams = lsqcurvefit(@(params, t)tpsf_fn_seminf(params(1), params(2), params(3), params(4), t, rho), ...
                           init, tof, tpsfData, [], [], options);
                       %Note: L-M doesn't handle bound constraints 
                       
[muA, muSp, ampl, t0] = deal(fittedparams(1),fittedparams(2),fittedparams(3),fittedparams(4));

if ~exist('plotThis', 'var') || plotThis
    figure;
    subplot(2,1,1)
    plot(tof, tpsfData)
    hold on
    plot(tof, tpsf_fn(muA, muSp, ampl, t0, tof, rho))
    legend('Measured', 'Fitted')
    ylabel('Intensity (# photons)')
    title(['TPSF \mu_A = ', num2str(muA),' cm^{-1}; \mu_S'' = ', num2str(muSp),' cm^{-1}']);
    subplot(2,1,2)
    semilogy(tof, tpsfData)
    hold on
    semilogy(tof, tpsf_fn(muA, muSp, ampl, t0, tof, rho))
    ylim([1, inf])
    legend('Measured', 'Fitted')
    xlabel('Time of Flight (ns)')
    ylabel('log Intensity (# photons)')
end




