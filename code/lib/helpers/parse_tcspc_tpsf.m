function [photonCounts, timeOfFlight] = parse_tcspc_tpsf(filenameSDT)
% Outputs:
%  photonCounts: number of photons arriving in the given time bin (using
%                arrival time from the micro clock)
%  timeOfFlight: time of flight of the photons (micro clock value) i.e. the
%                value of the time bins
%
% NOTE THAT THE LINE VALUES ARE HARD-CODED FOR 4096 TIME BINS IN THE TPSF

firstLine = 10; %TODO: look for "*BLOCK 1 Decay  ( Time[ns]  No_of_photons )"
lastLine = 4105; %TODO: look for "*END" after firstLine
sdtTpsfData = dlmread(filenameSDT, ' ', [firstLine, 0, lastLine, 1]);
timeOfFlight = sdtTpsfData(:,1);%*1e-9; %convert nanosec to sec
photonCounts = sdtTpsfData(:,2);