classdef ChunkIterator < handle
% Iterator for photon arrival times. Returns chunks of photons arrival
% times of specified size.
%
% See http://au.mathworks.com/matlabcentral/fileexchange/25225-design-pattern--iterator--behavioural-
%    for a more in-depth implementation of the Iterator pattern.
    
    properties(Access=private)
        times; % Array of photon arrival times
        chunkLen; % Length of chunk (in units of timer resolution)
        idx;  % Index of traversal
        avgIntensity;
    end
    
    methods
        function iterator = ChunkIterator(times, chunkLen) 
            %Constructor.
            iterator.times = times;
            if chunkLen > times(end);
                iterator.chunkLen = times(end);
            else
                iterator.chunkLen = chunkLen;
            end
            iterator.idx = 1;
            iterator.avgIntensity = length(times)/((times(end)-times(1))); 
        end
        
        
        function chunk = next(self)
            if ~self.has_next()
                chunk = [];
                return
            end
            
            chunk = []; %TODO: preallocate
            last = self.times(self.idx) + self.chunkLen;
            while self.times(self.idx) < last
                chunk(end+1) = self.times(self.idx);
                self.idx = self.idx+1;
            end
            % self.idx = self.idx-1; 

            %Skip chunk if intensity too low
%             chunkIntensity = length(chunk)/((chunk(end)-chunk(1)));
%             if chunkIntensity < self.avgIntensity/2
%                 chunk = self.next();
%             end
            
        end
        
        
        function tf = has_next(self)
            tf = self.times(self.idx) + self.chunkLen <= self.times(end);
        end
        
        
        function reset(self)
            % Position iterator at start.
            self.idx = 1;
        end
        
    end
end