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

if roiSize~=1
    % Downsample data before fft
    data = downSampleRoi(data, roiSize);
end

% Reorder dimensions for fft (convention)
dataForFFT = permute(data,[3,1,2]);

Y = fft(dataForFFT, n);     % DFT
power = Y.*conj(Y)/n;       % Power of the DFT
f = (0:n-1)*(fs/n);         % Frequency range

% Get index of dominant frequencies > 0.5Hz per ROI
validFreq = find(f>0.5);
f = f(validFreq);
power = power(validFreq(1):end/2,:,:);
[~, domFreqIdx] = max(power);

% Get pixel-wise dominant frequencies
domFreqs = f(domFreqIdx);
domFreqs = squeeze(domFreqs);

end
