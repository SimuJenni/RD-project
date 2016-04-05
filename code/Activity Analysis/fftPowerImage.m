function fftPowerImage( power, fileName, saveDir )
%FFTPOWERIMAGE Produces an activity image using the mean of the  provided 
%FFT-power as activity measure.

subplot(2,2,1);
% Compute the mean fft-power
activity = mean(power,1);

% Filter the result for better visualization
h=fspecial('gaussian',3,1);
activity = imfilter(squeeze(activity),h);

% Display
colormap jet
imagesc(activity)
title('{\bf Activity based on mean FFT-power}')
colorbar

end

