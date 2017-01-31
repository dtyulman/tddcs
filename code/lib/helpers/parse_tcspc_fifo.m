function [macroClock, microClock, invalid, overrun] = parse_tcspc_fifo(filenameSPC)

fifoData = dlmread(filenameSPC,' ', 0, 0);

macroClock = fifoData(:,1);
microClock = fifoData(:,2);
invalid = fifoData(:,3);
overrun = fifoData(:,4);

if any(invalid ~= 0)
    warning([filename '- Invalid photons.'])
end
if any(overrun ~= 0)
    warning([filename '- Photon overflow.'])
end
