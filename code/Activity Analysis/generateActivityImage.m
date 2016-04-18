function generateActivityImage( activity, titleText )
%GENERATEACTIVITYIMAGE produces an activity image of the given activity.
%Input:
%   activity - Activity image computed with fftPowerActivity or
%              computeEntropy
%   titleText - Title of the plot

% Display
imagesc(activity)
title(titleText)
colorbar

end
