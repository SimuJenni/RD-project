function activity = activityFromPower( power )
%ACTIVITYFROMPOWER Produces activity image using the mean of the provided 
%FFT or WT power as activity measure.
% Input:
%   power - Resulting 3D array (width x height x frames) of powers from FFT
%           or WT
% Output:
%   activity - 2D array of size (width x height) where power(i,j) is the
%              mean along power(i,j,:)
% See also PLOTRESULTS, COMPUTEENTROPY, WTANALYSIS, PERFORMFFT.

% Compute the mean fft-power
activity = mean(power,1);

% Filter the result for better visualization
h=fspecial('gaussian',3,1);
activity = imfilter(squeeze(activity),h);

end

