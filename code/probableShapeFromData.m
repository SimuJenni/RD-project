function [ shape ] = probableShapeFromData( dominantFreqs, phase, data,...
    fs )
%PROBABLESHAPEFROMDATA Computes the probable beating pattern from the
%results of the FFT and the underlying data.
%   Detailed explanation goes here

% Get frequency region with most ROIs
[N,edges] = histcounts(dominantFreqs(dominantFreqs>4),90);
[v, I] = max(N);
freqRange = edges(I:I+1);

% Length of region to extract
l = ceil(1.5*fs/freqRange(1));    

% Compute phase-shift
B = dominantFreqs*2*pi;
phase(phase>0)=phase(phase>0)-2*pi;     % Wrap phases around making all <0
phaseShift = -phase./B;
phaseShift = uint8(round(phaseShift*fs));   % Convert into frame-indices

% Shift the data so that all are in same phase
shiftData = zeros(size(data,1), size(data,2), l);
for i=1:size(data,1)
    for j=1:size(data,2)
        shiftData(i, j, :) = data(i, j, phaseShift(i, j)+1:phaseShift(i, j)+l);
    end
end
shiftData = reshape(shiftData,[],l);

% Compute shape as mean shape of curves within frequency range of interest
freqBand = dominantFreqs>freqRange(1) & dominantFreqs<freqRange(2);
shape = mean(shiftData(freqBand,:));
plot(shape);

end

