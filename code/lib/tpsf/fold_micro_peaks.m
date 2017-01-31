function [microFolded, countsFolded, tofFolded] = fold_micro_peaks(micro, verbose, maxTof, tpsfBins)
% Performs the TPSF folding operation on the micro clock values rather than
% the histogrammed photon counts (see also fold_tpsf)
% Inputs:
%   micro = micro clock time
%   maxTof = longest time of flight when recording the TPSF, in nanoseconds.
%            Defaults to 50
%   tpsfBins = number of time bins used when recording the TPSF. Defaults to
%              4096

if nargin < 4
    tpsfBins = 4096;
end
if nargin < 3
    maxTof = 50;
end
if nargin < 2
    verbose = false;
end

%Histogram the micro clock values
[counts, tofIdx] = histcounts(micro, 0:tpsfBins); 
tof = tofIdx(1:end-1)/tpsfBins*maxTof;

[countsFolded, ~, tofFolded, shifts, boundaries] = ...
                                     fold_tpsf_peaks(counts, tof, verbose);

microFolded = zeros(1,length(micro));
for i = 1:length(shifts)
    microFolded(boundaries(i)<=micro & micro<boundaries(i+1)) = ...
          micro(boundaries(i)<=micro & micro<boundaries(i+1)) - shifts(i);
end

[countsFolded2, tofIdx] = histcounts(microFolded, 0:max(microFolded)+1); 
tofFolded2 = tofIdx(1:end-1)/tpsfBins*maxTof;  
figure;
semilogy(tofFolded, countsFolded); hold on;
semilogy(tofFolded2, countsFolded2);




