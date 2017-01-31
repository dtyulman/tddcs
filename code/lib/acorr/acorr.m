function [acor, tau] = acorr(binned, binTime, alg)
% Inputs:
%  binned: vector of binned times e.g. [1,0,1,2] means 1 event in the
%          first interval of <binTime> seconds, 0 events in the second
%          interval, 1 event in the third interval, 2 events in the fourth
%  binTime: width of each bin, in seconds. <timerResolution> * <binWidth>
%  alg: optional argument to specify the algorithm to use. Options 'linear'
%       or 'progBin.' Default is 'linear'

maxlagtime = 1e-2; %only want lags <= 10^-2 secs

if nargin < 3 || strcmp(alg, 'linear')
%     loadWisdom();
    
    maxlags = round(maxlagtime/binTime); 
    
    X = fft(binned);
    acor = ifft(abs(X).^2, 'symmetric');
    acor = acor(2:maxlags); %remove unnecessary lags
    acor = acor*length(binned)./sum(binned).^2; %normalize intensity
    
    tau = (1:maxlags-1)*binTime; %convert lags to seconds
             
%     saveWisdom()
elseif strcmp(alg, 'progBin') %As described in The B&H TCSPC Handbook, 6th Edition
    %TODO: double check this
    warning('I think this is wrong')
    
    rebinningFactor = 3; %From handbook: "The factor of three is used
    % to keep the new time intervals centred at multiples of the original time
    % channel width, T."
    kTau = rebinningFactor*10; %must be a multiple of rebinningFactor to avoid
    % double-counting or skipping bins
    
    lagsPerIter = kTau;
    
    normFactor = length(binned)/sum(binned)^2;
    
    len = ceil(max(roots([1,1,(-2*maxlagtime)/((kTau+rebinningFactor-1)*binTime)])))
    acor = nan(1, len);
    tau = nan(1, len);
    
    shift = 0;
    idx = 1;
    %     while tau(end) < 1e-3 %only want lags < 10^-3 secs
    for j = 1:len/kTau
        for i = 1:lagsPerIter
            shift = shift + 1;
            acor(idx) = sum( binned(1+shift:end).*binned(1:end-shift) )...
                * normFactor;
            
            tau(idx) = shift*binTime;
            idx = idx + 1;
        end
        
        binned = rebin(binned, rebinningFactor);
        normFactor = length(binned)/sum(binned)^2;
        binTime = binTime*rebinningFactor;
        shift = shift/rebinningFactor;
        for i = ceil(-rebinningFactor/2):floor(rebinningFactor/2)
            if mod(shift + kTau+i, 3) == 0
                lagsPerIter = kTau+i;
            end
        end
    end
    
    acor = acor(~isnan(acor));
    tau = tau(~isnan(tau));
    
else
    error('Invalid algorithm option')
end

end

%-- Helpers ---------------------------------------------------------------
function rebinned = rebin(binned, binWidth)

rebinned = zeros(1, floor(length(binned)/binWidth));
for i = 1:length(binned)-mod(length(binned), binWidth)
    rebinned(ceil(i/binWidth)) = rebinned(ceil(i/binWidth)) + binned(i);
end

end


function loadWisdom()

curdir = pwd;
cd(fileparts(mfilename('fullpath')))
load('fftwisdom.mat', 'wis');
cd(curdir)

fftw('wisdom', wis);
fftw('planner', 'hybrid');

end


function saveWisdom()

wis = fftw('wisdom'); 

curdir = pwd;
cd(fileparts(mfilename('fullpath')))
save('fftwisdom.mat', 'wis');
cd(curdir)

end
