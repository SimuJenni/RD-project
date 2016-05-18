function dominantPhaseImage( domPhase, titleText )
%DOMINANTPHASEIMAGE produces an image of the given dominant phases per ROI.
%Input:
%   domPhase - Matrix of dominant frequencies per ROI

%   titleText - Title of the plot

% Display
imagesc(domPhase)
title(titleText)
colorbar
end

