function generatedOscilations = generateSyntheticData( shapeFun, dim, ...
    freqs, amps, phases, density )
%GENERATESYNTHETICDATA Summary of this function goes here
%   Detailed explanation goes here

% Extract dimensions
width = dim(1);
height = dim(2);
duration = dim(3);

% Generate time-series for the specified duration
Fs = 90;                    % samples per second (fixed!)
t = (0:1/Fs:duration-1/Fs)';   

% 2D cell array holding the generated oscilations
generatedOscilations = zeros(width, height, duration*Fs);

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
        generatedOscilations(i,j,:) = shapeFun(freq, amp, phase, t);
    end    
end

end
