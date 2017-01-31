function [intensity, time] = plot_intensity(photonArrivalTimes, binTime, timerRes)
% Inputs:
%  photonArrivalTimes: vector of photon arrival times, in units of the timer's
%         resolution. Should only contain integers. 
%  binWidth: width of the bin, in seconds. 
%  timerRes: timer's resolution (i.e. if a value in photonTimes is "n",
%            then the actual photon arrival time is n*timerRes). Defaults
%            to 50 ns. 
% Outputs: (if no output arguments provided, simply plots the data)
%   intensity: photons per second for each bin
%   time: time associated with each bin, in seconds

if nargin < 3
    timerRes = 50e-9;
end
if nargin < 2
    binTime = 0.005;
end

binWidth = round(binTime/timerRes); %convert to units of timerRes

binned = times_to_bins(photonArrivalTimes, binWidth);
intensity_tmp = binned/binTime;
time_tmp = (1:length(intensity_tmp))*binTime;

if nargout == 0
    figure;
    plot(time_tmp, intensity_tmp)
    ylabel('Intensity (photons/second)')
    xlabel('Time (seconds)')
    title(sprintf('Averaged (bin width = %.3f sec) intensity of photon stream.', binTime))
else %TODO there must be a better way to do this...
    intensity = intensity_tmp;
    time = time_tmp;
end

