function [acor, tau, macroGated, photonsGated, fluxGated] = ...
    acorr_gated(macro, microFolded, gateStartSec, gateEndSec, maxLag, tpsfRes, timerRes)
% Inputs:
%  macro: macro clock photon arrival times (in units of timerRes)
%  micfoFolded: micro clock photon arrivals, ranging over one TPSF, in
%               units of timerRes
%  gateStartSec: shortest time-of-flight to consider when computing
%                    autocorrelation, in seconds
%  gateEndSec: longest time-of-flight

if nargin < 7
    timerRes = 50e-9;
end
if nargin < 6
    tpsfRes = 50e-9/4096;
end

gateStart = gateStartSec/tpsfRes; %convert to units of tpsfRes
gateEnd = gateEndSec/tpsfRes;
macroGated = macro( gateStart <= microFolded ...
                               & microFolded <= gateEnd );
if isempty(macroGated)
    error('No photons inside gate')
end

photonsTotal = length(macro);
fluxTotal = photonsTotal/(macro(end)*timerRes - macro(1)*timerRes);
disp(['Total flux: ' num2str(fluxTotal) ' ph/s'])
disp(['Total photons: ' num2str(photonsTotal)])

photonsGated = length(macroGated);
fluxGated = photonsGated/(macroGated(end)*timerRes - macroGated(1)*timerRes);
disp(['Gated flux: ' num2str(fluxGated) ' ph/s'])
disp(['Gated photons: ' num2str(photonsGated)])

if photonsGated > 100e6
    macroGated = macroGated(1:100e6);
    warning('Only using first 100 million photons')
end

if nargin < 5
    maxLag = 1e-2;
end
[acor, tau] = acorr_times(macroGated, maxLag, timerRes);

