function [acor, tau] = acorr_avg(times, chunkLen, binWidth, timerRes)
% Computes the autocorrelation by breaking the arrival times into chunks of
% chunkLen (units of timerRes), computing acorr on each one, and averaging.
% All but the first argument are optional, or pass in [] to leave default.
% Defaults: chunkLen = 1/timerRes (one second, if timerRes is default)
%           timerRes = 50e-9 seconds
%           binWidth = 1

if nargin < 4 || isempty(timerRes)
    timerRes = 50e-9; %seconds
end
if nargin < 3 || isempty(binWidth)
    binWidth = 1; 
end
if nargin < 2 || isempty(chunkLen)
    chunkLen = 1/timerRes; %one-second chunks
end
binTime = binWidth*timerRes;
times = times-times(1);

avgIntensity = length(times)/(times(end)*timerRes);
disp(['Total time: ' num2str(times(end)*timerRes) ' secs'])
disp(['Average flux: ' num2str(avgIntensity) ' photons/sec'])

acor = 0; 
ctr = 0;
chunker = ChunkIterator(times, chunkLen);
% figure; %for debugging
while chunker.has_next()
    chunk = chunker.next();
    
    chunkIntensity = length(chunk)/((chunk(end)-chunk(1))*timerRes);
    if chunkIntensity < avgIntensity/2
        %ignore chunks that might have errors in them, e.g. massive drops in intensity 
        warning(['Low flux! Skipping chunk ' num2str(chunk(1)*timerRes, '%.2f') ...
            '-' num2str(chunk(end)*timerRes, '%.2f') ' secs (' ... 
            num2str(chunkIntensity) ' ph/s)'])
        continue
    end
      
    disp(['Autocorrelating chunk ' num2str(chunk(1)*timerRes, '%.2f') ...
          '-' num2str(chunk(end)*timerRes, '%.2f') ' secs ('...
          num2str(chunkIntensity) ' ph/s)']);
    
    binned = times_to_bins(chunk, binWidth);
    [acorChunk, tau] = acorr(binned, binTime);
    
    
    %{  
    [acorChunkMt, tauMt] = rebin_to_multitau(acorChunk, tau);
    semilogx(tauMt, acorChunkMt);
    hold on; %for debugging
    %}
    
    acor = acor + acorChunk;
    ctr = ctr+1;   
end

acor = acor/ctr;

