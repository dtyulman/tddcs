function [countsFolded, folds, tofFolded, shifts, boundaries] = ...
                                      fold_tpsf_peaks(counts, tof, verbose)

if ~isrow(counts)
    counts = counts';
end

[~, peakIdxs] = findpeaks(counts, 'MinPeakProminence', max(counts)/2);

if isempty(peakIdxs)
    figure;
    semilogy(counts)
    errormsg = 'Could not find any peak of a TPSF';
    title(['Error: ' errormsg]);
    error(errormsg)    
elseif length(peakIdxs) == 1
    warning('Only one TPSF detected. No folding is done')
    countsFolded = counts;
    tofFolded = tof;
    shifts = [];
    return
end

invCounts = max(counts)-counts;
[~,valleyIdxs] = findpeaks(invCounts, 'MinPeakProminence', max(invCounts)/2);
valleyIdxs = valleyIdxs(peakIdxs(1) < valleyIdxs & valleyIdxs < peakIdxs(end));
boundaries = [1, valleyIdxs, length(counts)+1];

shifts = peakIdxs-peakIdxs(1);
folds = zeros(length(peakIdxs), valleyIdxs(1)); %TODO if too small
for i = 1:length(peakIdxs)
    idxs = boundaries(i):boundaries(i+1)-1;
    folds(i,idxs-shifts(i)) = counts(idxs);
end

countsFolded = sum(folds);
tofFolded = tof(1:length(countsFolded));

if exist('verbose', 'var') && verbose
    figure;
    semilogy(tof, counts); hold on
    scatter(tof(peakIdxs), counts(peakIdxs))
    for i = 1:length(valleyIdxs)
        plot(ones(1,2)*tof(valleyIdxs(i)), [1, max(counts)*100], 'k--')
    end
    xlabel('Time of flight (ns)')
    ylabel('# photons')
    title('Input data')
    
    figure;
    subplot(1,2,1)
    semilogy(tofFolded, folds) 
    xlabel('Time of flight (ns)')
    ylabel('# photons')
    title('Individual folds')
    
    subplot(1,2,2)
    semilogy(tofFolded, countsFolded) 
    xlabel('Time of flight (ns)')
    title('Total counts, folded')
end

                






