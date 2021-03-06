function [ power, f, domFreqs, domPhase ] = performFFT( data, fs )
%PERFORMFFT performs frequency analysis using the fast fourier transform
% Input:
%   data - 3D array of extracted video data (width x height x frames)
%   fs - Sampling frequency of the input data
% Output:
%   power - Power of resulting discrete fourier transform
%   f - Frequency range
%   domFreqs - Dominant frequency per region of interest 
%   domPhase - Phase corresponding to dominant frequency
% See also BATCHANALYSEFOLDER, WTANALYSIS.


m = size(data,3);           % Window length
n = pow2(nextpow2(m));      % Transform length

% Reorder dimensions for fft (convention)
data = single(permute(data,[3,1,2]));   % Use single because of memory

Y = fft(data, n);           % DFT
clear data;
power = Y.*conj(Y)/n;       % Power of the DFT
phase = angle(Y);

clear Y;
f = (0:n-1)*(fs/n);         % Frequency range

% Get index of dominant frequencies > 1Hz per ROI
validFreq = find(f>2 & f<fs/2);
f = f(validFreq);
power = power(validFreq(:),:,:);
phase = phase(validFreq(:),:,:);
[~, domFreqIdx] = max(power);

% Get pixel-wise dominant frequencies
domFreqs = f(domFreqIdx);
domFreqs = squeeze(domFreqs);

% And corresponding phase
domPhase = zeros(size(phase,2), size(phase,3));
for i=1:size(phase,2)
    for j = 1:size(phase,3)
        domPhase(i, j) = phase(domFreqIdx(1, i, j), i, j);
    end
end

end

