function [ shape ] = probableShapeFromData( dominantFreqs, phase, data,...
    activity, fs )
%PROBABLESHAPEFROMDATA Computes the probable shape of the beating pattern 
%from the results of the FFT and the underlying data.
%Note: The FFT should be computed using ROI-size=1 for use with this 
%function.
% Input:
%   dominantFreqs - 2D array of size (w x h) with dominant frequencies per 
%                   pixel 
%   phase - 2D array of corresponding phases per pixel
%   data - 3D array of extracted video data of size (w x h x t)
%   activity - 2D array of activities phases per pixel
%   fs - Sampling frequency of the input data
% Output:
%   shape - Curve fitted to the data using smoothing-splines
% See also PERFORMFFT, COMPUTEENTROPY, ACTIVITYFROMPOWER.

% Get frequency region with most ROIs
[N,edges] = histcounts(dominantFreqs(dominantFreqs>4),200);
[v, I] = max(N);
freqRange = edges(I:I+1);

% Activity-band
minActivity = quantile(activity(:), 0.9);
activityBand = activity>minActivity;

% Length of region to extract
l = ceil(2*fs/freqRange(1));    

% Compute phase-shift
B = dominantFreqs*2*pi;
phase(phase>0)=phase(phase>0)-2*pi;     % Wrap phases around making all <0
phaseShift = -phase./B;

% The time axis
X = repmat((0:l-1)/fs, numel(phaseShift), 1) - repmat(phaseShift(:), 1, l);
% Corresponding data
Y = double(reshape(data(:,:,1:l), [], l));

% Frequencies and data of interrest
freqBand = dominantFreqs>freqRange(1) & dominantFreqs<freqRange(2);
valid = freqBand & activityBand;
X = X(valid(:),:);
Y = Y(valid(:),:);

% Fit using splines and plot
shape = fit(X(:), Y(:),  'smoothingspline', 'SmoothingParam', 0.4);
plot(shape,X(:), Y(:));


end

