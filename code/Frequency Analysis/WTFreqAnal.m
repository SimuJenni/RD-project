function [ power, f, domFreqs ] = WTFreqAnal( data, fs )
%WTFREQANAL performs frequency analysis using the continuous
%wavelet-transform.
% Input:
%   data - 3D array of extracted video data (width x height x frames)
%   fs - Sampling frequency of the input data
% Output:
%   power - Power of resulting discrete fourier transform
%   f - Frequency range
%   domFreqs - Dominant frequency per region of interest 

% Reorder dimensions
data = single(permute(data,[3,1,2]));   % Use single because of memory

waveletType = 'morl';

% Center frequency of wavelet-type
f0 = centfrq(waveletType);
dt = 1/fs;
scales = helperCWTTimeFreqVector(1,45,f0,dt,16);

% Perform CWT ROI-wise
power = zeros(length(scales), size(data,2), size(data,3));
for row = 1:size(data,2)
    for col = 1:size(data,3)
        cwt_res = cwtft({data(:,row,col), dt},'wavelet',waveletType,'scales',scales);
        p = abs(cwt_res.cfs).^2;
        power(:, row, col) = mean(p,2);
    end
end
f = cwt_res.frequencies;

% Get index of dominant frequencies
[~, domFreqIdx] = max(power);

% Get pixel-wise dominant frequencies
domFreqs = f(domFreqIdx);
domFreqs = squeeze(domFreqs);

end

