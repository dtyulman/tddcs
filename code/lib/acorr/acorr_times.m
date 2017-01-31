function [acor, tau] = acorr_times(macro, maxLagTime, timerRes)
% Computes the autocorrelation directly from the photon arrival times

if nargin < 3
    timerRes = 50e-9;
end
if nargin < 2
    maxLagTime = 5e-3;
end

maxLag = ceil(maxLagTime/timerRes);
acor = zeros(1, maxLag);
diffs = diff(macro);
for i = 1:length(diffs)
    j = 0;
    cumulative = 0;
    while i+j <= length(diffs) && cumulative+diffs(i+j) <= maxLag
        cumulative = cumulative+diffs(i+j);
        if cumulative > 0
            acor(cumulative) = acor(cumulative)+1;
        end
        j = j + 1;
    end
end

%Normalize
acor = acor * (macro(end)-macro(1)) / length(macro)^2;
tau = (1:length(acor))*timerRes;

