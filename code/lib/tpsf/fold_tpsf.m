function [countsFolded, tofFolded, shifts] = fold_tpsf(counts, tof, verbose)
% Inputs:
%  counts - histogrammed "micro clock" photon counts
%  tof - time of flight (micro clock values)
%
% Technically, the correct fold size is tpsfBins/(tofMax/pulsePeriod), but
% that's usually a non-integer so use autocorrelation to determine optimal
% fold size for each peak

if ~isrow(counts)
    counts = counts';
end

%Find peak locations
acor=xcorr(counts, 'unbiased');
acor=acor(ceil(length(acor)/2):end);
[~, shifts] = findpeaks(acor, 'MinPeakProminence', acor(1)/4);

if verbose, 
    figure; 
    if exist('tof', 'var')
        semilogy(tof, counts)
    else
        semilogy(counts)
    end
    title('Input')
    figure;
    subplot(1,2,1); 
    semilogy(counts); hold on;
end

%Fold based on autocorrelation peaks
countsFolded = counts;
for shift = shifts
    countsFolded(1:end-shift) = countsFolded(1:end-shift) + counts(1+shift:end);
    if verbose 
        semilogy(counts(1+shift:end)); 
    end
end

%Return only the first peak onto which all others were folded
first = find(counts>0, 1);
minFoldLength = min(diff( [0, shifts, length(counts)] ));
last  = first + minFoldLength;
countsFolded = countsFolded(first:last);

if verbose 
    xlim([first,last]); 
    subplot(1,2,2); 
    semilogy(countsFolded); 
end


%Return relevant time of flight information, if needed
if nargout > 1
    if nargin < 2
        error('Must provide time of flight as second argument')
    end
    tofFolded = tof(first:last);
    
    if verbose 
        figure; 
        semilogy(tofFolded, countsFolded);
        title('Folded')
    end
end










