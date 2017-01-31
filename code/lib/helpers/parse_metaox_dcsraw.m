function [acor, tau] = parse_metaox_dcsraw(filenameDCSRAW, recordingTimeSecs)
% Inputs:
%   filenameDCSRAW: filename with .dcsraw extension
%   recordingTimeSecs: (optional, but improves performance) length of time
%                      for which the DCS recording was done, in seconds
%
% Assumes that a correlation curve is taken every half a second, and
% produces 128 points per curve.

if ~strcmp('.dcsraw', filenameDCSRAW(end-6:end))
    error('Must input a .dcsraw file')
end

if exist('recordingTimeSecs', 'var')
    nCurves = recordingTimeSecs*2;
    acors = zeros(128,nCurves);
end

fid = fopen(filenameDCSRAW);
curveNum = 0;
while ~feof(fid)
    curveNum = curveNum + 1;
       
    %only reads first two columns (taus, and detector 1 acorr)
    raw = textscan(fid, '%f %f %*[^\n]', 128, 'CommentStyle', 'CPS');
    if isempty(raw{1})
        continue
    end
    
    if ~exist('tau', 'var')
        tau = raw{1};
    else
        if ~all(tau==raw{1})
            error('Different taus between curves')
        end
    end
    
    acors(:,curveNum) = raw{2};
end
fclose(fid);

acor = mean(acors,2)';
tau = tau';







