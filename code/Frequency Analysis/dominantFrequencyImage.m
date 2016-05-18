function dominantFrequencyImage( domFreqs, titleText )
%DOMINANTFREQUENCYIMAGE produces an image of the given dominant freqeuncies
%per ROI.
%Input:
%   domFreqs - Matrix of dominant frequencies per ROI
%   titleText - Title of the plot

% Display
imagesc(domFreqs)
title(titleText)
colorbar

end


