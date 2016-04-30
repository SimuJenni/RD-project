function plotResults( data, power, f, domFreqs )
%PLOTRESULTS Manages the creation of plots for all results.

%% Activity images first
% FFT power 
subplot(3,3,1);
generateActivityImage( fftPowerActivity(power), 'Activity: FFT-Power' );

% Entropy 
subplot(3,3,2);
activity = computeEntropy(data);
generateActivityImage( activity, 'Activity: Entropy' );

% The mask
subplot(3,3,3);
mask = activityMask( activity, 0.25, 0.75 );
generateActivityImage( mask, 'Activity Mask' );

%% The average spectrum over all ROI
subplot(3,3,4);
meanPower = mean(mean(power,2),3);
spectrumPlot( meanPower, f, 'Average CBF Spectrum' )

%% The average spectrum over masked ROI
subplot(3,3,5);
maskedPower = power(:,mask);
meanPower = mean(maskedPower,2);
spectrumPlot( meanPower, f, 'Average CBF Spectrum (Masked)' )

%% Distribution of dominant frequencies
subplot(3,3,6);
dominantFrequencyImage( domFreqs, 'Dominant Frequencies per ROI' );

%% Spectrum of ROI with maximal power
subplot(3,3,7);
[~, idx] = max(activity(:));
[row,col] = ind2sub([size(power,2), size(power,3)], idx);
spectrumPlot( power(:,row,col), f, 'Max Activity Spectrum' )

%% Spectrum of ROI with maximal power over mask
subplot(3,3,8);
[~, idx] = max(activity(:).*mask(:));
[row,col] = ind2sub([size(power,2), size(power,3)], idx);
spectrumPlot( power(:,row,col), f, 'Max Activity Spectrum (Masked)' )

%% Distribution of dominant frequencies
subplot(3,3,9);
maskedFreqs = domFreqs(mask);
histogram(maskedFreqs(maskedFreqs<46),100);
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Dominant Frequencies per ROI (Masked)}')

end

