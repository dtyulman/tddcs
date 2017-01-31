function [acor, tau] = parse_acorrfile(filename)

if strcmp('.dcsraw', filename(end-6:end))
    [acor, tau] = parse_metaox_dcsraw(filename);
elseif strcmp('.sdt.asc', filename(end-7:end))
    [acor, tau] = parse_tcspc_corr(filename);
elseif strcmp('DCS_', filename(1:4)) && strcmp('.dat', filename(end-3:end))
    [acor, tau] = parse_dcs2_corr(filename);
else
    error('Invalid filename. Must be either .dat, .dcsraw, or .sdt.asc')
end
