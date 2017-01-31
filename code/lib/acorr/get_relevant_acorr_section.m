function [acorRelevant, tauRelevant, minTauIdx, maxTauIdx] = get_relevant_acorr_section(acorAll, tauAll, minTau, maxTau);
% minTau: smallest lag to look at (in seconds)
% maxTau: largest lag (in seconds)

if length(acorAll) ~= length(tauAll)
    error('Autocorrelation sequence must be same length as tau sequence')
end


[~, minTauIdx] = min(abs(tauAll-minTau));
[~, maxTauIdx] = min(abs(tauAll-maxTau));
if minTauIdx < 1
    minTauIdx = 1;
end
if maxTauIdx > length(tauAll)
    maxTauIdx = length(tauAll);
end

acorRelevant = acorAll(minTauIdx:maxTauIdx);
tauRelevant  = tauAll(minTauIdx:maxTauIdx);
