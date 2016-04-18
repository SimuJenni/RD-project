function activity = fftPowerActivity( power )
%FFTPOWERActivity Produces an activity image using the mean of the  provided 
%FFT-power as activity measure.

% Compute the mean fft-power
activity = mean(power,1);

% Filter the result for better visualization
h=fspecial('gaussian',3,1);
activity = imfilter(squeeze(activity),h);

end

