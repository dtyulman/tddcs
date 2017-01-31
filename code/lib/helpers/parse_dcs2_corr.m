function [acor, tau] = parse_dcs2_corr(filenameDCS)
% Outputs:
%  acorr: autocorrelation values
%  tau: lags, in seconds

tau = load('dcs2_taus_512.txt')';

fid = fopen(filenameDCS);
acors = fread(fid, [512, inf], 'double');
fclose(fid);

acor = mean(acors,2,'omitnan')';

return


