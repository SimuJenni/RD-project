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
[N,edges] = histcounts(dominantFreqs(dominantFreqs>4),400);
[v, I] = max(N);
freqRange = edges(I:I+1);

% Activity-band
minActivity = quantile(activity(:), 0.95);
maxActivity = quantile(activity(:), 1);

activityBand = activity>=minActivity & activity<=maxActivity;

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

% Fit using weighted linear least squares with 1st degree polynomial model
scatter(X(:),Y(:));
x = linspace(min(X(:)),max(X(:)));
shape = mylowess([X(:),Y(:)],x,0.2);
line(x, shape, 'color', 'r', 'linestyle', '-', 'linewidth', 2.5);

end

function ys=mylowess(xy,xs,span)
%MYLOWESS Lowess smoothing, preserving x values
%   YS=MYLOWESS(XY,XS) returns the smoothed version of the x/y data in the
%   two-column matrix XY, but evaluates the smooth at XS and returns the
%   smoothed values in YS.  Any values outside the range of XY are taken to
%   be equal to the closest values.

if nargin<3 || isempty(span)
    span = .3;
end

% Sort and get smoothed version of xy data
xy = sortrows(xy);
x1 = xy(:,1);
y1 = xy(:,2);
ys1 = smooth(x1,y1,span,'loess');

% Remove repeats so we can interpolate
t = diff(x1)==0;
x1(t)=[]; ys1(t) = [];

% Interpolate to evaluate this at the xs values
ys = interp1(x1,ys1,xs,'linear',NaN);

% Some of the original points may have x values outside the range of the
% resampled data.  Those are now NaN because we could not interpolate them.
% Replace NaN by the closest smoothed value.  This amounts to extending the
% smooth curve using a horizontal line.
if any(isnan(ys))
    ys(xs<x1(1)) = ys1(1);
    ys(xs>x1(end)) = ys1(end);
end

end