function binned = times_to_bins(times, binWidth)
% Inputs:
%  times: vector of photon arrival times, in units of the timer's
%         resolution. Should only contain integers. 
%  binWidth: width of the bin, in units of the timer's resolution. Can be
%           greater than zero if you want to oversample the times vector.
%           Defaults to 1. 

if nargin < 2
    binWidth = 1;
end

times = times - times(1) + 1; %shift times s.t. first value is "1"
times = times/binWidth;
nBins = ceil( times(end) ); 
times = ceil(times);

binned = zeros(1, nBins);
for i = 1:length(times)
    idx = times(i);
    binned(idx) = binned(idx) + 1;
end

if binWidth > 1
    binned = binned(1:end-1); %last bin might be invalid
end