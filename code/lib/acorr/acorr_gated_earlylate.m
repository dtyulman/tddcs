function [acorEarly, acorLate, tau] = acorr_gated(macro, microFolded, gateTimeNanosec, tpsfRes, timerRes)
% Inputs:
%  macro: macro clock photon arrival times (in units of timerRes)
%  micfoFolded: micro clock photon arrivals, ranging over one TPSF, in
%               units of timerRes
%  gateTimeNanosec: time at which to separate the "early" photons from the
%               "late" photons, in nanoseconds

if nargin < 5
    timerRes = 50e-9;
end
if nargin < 4
    tpsfRes = 50e-9/4096;
end

macroEarly = macro( microFolded <= (gateTimeNanosec*1e-9/tpsfRes) );
macroLate  = macro( microFolded >  (gateTimeNanosec*1e-9/tpsfRes) );


fluxTotal = length(macro)/(macro(end)-macro(1))/timerRes;
fluxEarly = length(macroEarly)/(macroEarly(end)-macroEarly(1))/timerRes;
fluxLate  = length(macroLate)/(macroLate(end)-macroLate(1))/timerRes;
disp(['Total flux: ' num2str(fluxTotal) ' photons/sec'])
disp(['Early flux: ' num2str(fluxEarly) ' photons/sec'])
disp(['Late flux:  ' num2str(fluxLate)  ' photons/sec'])


[acorEarly, tau] = acorr_avg(macroEarly, [], [], timerRes);
acorLate         = acorr_avg(macroLate,  [], [], timerRes);

