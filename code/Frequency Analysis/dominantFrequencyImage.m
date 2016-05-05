function dominantFrequencyImage( domFreqs, titleText )
%DOMINANTFREQUENCYIMAGE produces an activity image of the given activity.
%Input:
%   domFreqs - Activity image computed with fftPowerActivity or
%              computeEntropy
%   titleText - Title of the plot

% Display
imagesc(domFreqs)
title(titleText)
colorbar

end


