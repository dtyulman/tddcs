function [acorReb, tauReb] = rebin_to_multitau(acor, tau, nBins, binFactor)

if nargin < 4
    binFactor = 3; %factor by which binWidth increases after nBins iterations
end
if nargin < 3
    nBins = 30; %number of consecutive bins before increasing width
end

acorReb = [];
tauReb = [];

binWidth = 1; %starting bin width
binSum = 0;
ctr = 0;
binCtr = 0;
for i = 1:length(acor)
    binSum = binSum + acor(i);
    ctr = ctr + 1;
    if ctr == binWidth
        acorReb(end+1) = binSum/binWidth;
        tauReb(end+1) = tau(i-floor(binWidth/2));
        ctr = 0;
        binSum = 0;
        binCtr = binCtr+1;
        if binCtr == nBins
            binWidth = binWidth*binFactor;
            binCtr = 0;
        end
    end
end
    
%TODO: make this less of a hack...