function maxEntropyImage( power, fileName, saveDir )
%FFTPOWERIMAGE Produces an activity image using the mean of the  provided 
%FFT-power as activity measure.
    
% use pyulear (make few tests) and the make it like fftPowerImage.
% Pxx should give the power, like we want for the fft.

subplot(2,2,1);
% Compute the mean fft-power
activity = mean(power,1);
%activity = pburg( videoFrames, order )

% Filter the result for better visualization
h=fspecial('gaussian',3,1);
activity = imfilter(squeeze(activity),h);

% Display
colormap jet
imagesc(activity)
title('{\bf Activity based on max entropy}')
colorbar

end

