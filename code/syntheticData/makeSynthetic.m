function synthData = makeSynthetic(oscFun, dim, freqs, amps, phases, ...
    density)
%MAKESYNTHETIC generates synthetic test-data. 
% synthData = makeSynthetic( oscFun, dim, freqs, amps, phases, density )
% Input:
%   oscFun - oscilation pattern function oscFun(freq, amp, phase, t) 
%   dim - Output dimensions [width x height x duration(in seconds!)]
%   freqs, amps, phases - Parameter arrays for oscFun (sampled unformly)
%   density - Float in [0,1] specifying pixel-density of oscilations 
% See also SIMPLESINE.

% Extract dimensions
width = dim(1);
height = dim(2);
duration = dim(3);

% Generate time-series for the specified duration
Fs = 90;                    % samples per second (fixed!)
t = (0:1/Fs:duration-1/Fs)';   

% 2D cell array holding the generated oscilations
synthData = zeros(width, height, duration*Fs);

% Sample parameters for generated oscilations
genFreqs = datasample(freqs,width*height);
genAmps = datasample(amps,width*height);
genPhases = datasample(phases,width*height);

for i=1:width
    for j=1:height
        if rand>density
            continue;
        end
        % Get corresponding parameters
        idx = sub2ind([width, height],i,j);
        freq = genFreqs(idx);
        amp = genAmps(idx);
        phase = genPhases(idx);
        % Generate the oscilation
        synthData(i,j,:) = oscFun(freq, amp, phase, t);
    end    
end

synthData = subtractMean(single(synthData));

end

