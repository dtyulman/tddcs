% function [microFolded, countsFolded, tofFolded] = fold_micro(micro, verbose, maxTof, tpsfBins)
function [microFolded, countsFolded, tofFolded] = fold_micro(micro, microRes, verbose)

% Performs the TPSF folding operation on the micro clock values rather than
% the histogrammed photon counts (see also fold_tpsf)
% Inputs:
%   micro = micro clock time
%   maxTof = longest time of flight when recording the TPSF, in nanoseconds.
%            Defaults to 50
%   tpsfBins = number of time bins used when recording the TPSF. Defaults to
%              4096

% if nargin < 4
%     tpsfBins = 4096;
% end
% if nargin < 3
%     maxTof = 50;
% end
% if nargin < 2
%     verbose = false;
% end
if nargin < 3
    verbose = false;
end
 
%Histogram the micro clock values
% [counts, tofIdx] = histcounts(micro, 0:tpsfBins); 
% tof = tofIdx(1:end-1)/tpsfBins*maxTof;
[counts, tofIdx] = histcounts(micro, 0:max(micro)); 
tof = tofIdx(1:end-1)*microRes;

%Fold histogrammed values to get shifts
[countsFolded, tofFolded, shifts] = fold_tpsf(counts, tof, verbose);

%Shift the micro clock values
microFolded = micro;
for shift = shifts
    foldIdxs = (micro >= shift);
    microFolded(foldIdxs) = micro(foldIdxs) - shift;
end


