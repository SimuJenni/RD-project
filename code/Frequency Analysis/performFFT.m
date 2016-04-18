function [ power, f, domFreqs ] = performFFT( data, fs, roiSize )
%PERFORMFFT performs frequency analysis using the fast fourier transform
% Input:
%   data - 3D array of extracted video data (width x height x frames)
%   fs - Sampling frequency of the input data
%   roiSize - Region of interest size
% Output:
%   power - Power of resulting discrete fourier transform
%   f - Frequency range
%   domFreqs - Dominant frequency per region of interest 

m = size(data,3);           % Window length
n = pow2(nextpow2(m));      % Transform length

% Reorder dimensions for fft (convention)
data = single(permute(data,[3,1,2]));   % Use single because of memory

Y = fft(data, n);           % DFT
clear data;
power = Y.*conj(Y)/n;       % Power of the DFT
clear Y;
f = (0:n-1)*(fs/n);         % Frequency range

% Get index of dominant frequencies > 1Hz per ROI
validFreq = find(f>1);
f = f(validFreq);
power = power(validFreq(:),:,:);
[~, domFreqIdx] = max(power);

% Get pixel-wise dominant frequencies
domFreqs = f(domFreqIdx);
domFreqs = squeeze(domFreqs);

end

