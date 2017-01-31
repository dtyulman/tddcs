function [acorr, tau] = parse_tcspc_corr(filenameSDT)
% Outputs:
%  acorr: autocorrelation values
%  tau: lags, in seconds


data = importdata(filenameSDT,'\n'); %TODO: this is a hack, reads the data 2x

firstLine = find( ~cellfun('isempty',strfind(data,'( Time[µs]  FCS_value )')), 1, 'first' );
lastLine = find( ~cellfun('isempty',strfind(data,'*END')), 1, 'last') - 2;
sdtFcsData = dlmread(filenameSDT, ' ', [firstLine, 0, lastLine, 1]);
tau = sdtFcsData(:,1)*1e-6; %convert microsec to sec
acorr = sdtFcsData(:,2);

%Something like:
% fid = fopen(filename, 'r');
% s = textscan(fid, '%s', 'delimiter', '\n');
% firstLine = find(strcmp(s{1}, '*BLOCK 1 Fcs'), 1, 'first')+3;
% lastLine = find(strcmp(s{1}, '*END'), 1, 'last');
% fclose(fid);
%Or maybe use grep