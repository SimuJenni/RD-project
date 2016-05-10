function entropy = plotResults( data, power, f, domFreqs, activityWT, powerWT, fWT, domFreqsWT )
%PLOTRESULTS Manages the creation of plots for all results.

%% Activity images first
% FFT power 
subplot(4,3,1);
generateActivityImage( fftPowerActivity(power), 'Activity: FFT-Power' );

% Entropy 
subplot(4,3,2);
entropy = computeEntropy(data);
generateActivityImage( entropy, 'Activity: Entropy' );

% The mask
subplot(4,3,3);
mask = activityMask( entropy, 0.25, 0.75 );
generateActivityImage( mask, 'Activity Mask' );

% Activity with WT
subplot(4,3,4);
generateActivityImage( activityWT, 'Activity: Wavelet Transform');

%% Dominant frequencies per ROI image with WT
subplot(4,3,5);
dominantFrequencyImage( domFreqsWT, 'Dominant Frequencies per ROI with WT' );

%% Distribution of dominant frequencies with WT
subplot(4,3,6);
maskedFreqs = domFreqsWT(mask);
histogram(maskedFreqs(maskedFreqs<45),100);
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Dominant Frequencies per ROI with WT(Masked)}')

%% The average spectrum over all ROI
subplot(4,3,7);
meanPower = mean(mean(power,2),3);
spectrumPlot( meanPower, f, 'Average CBF Spectrum' )

%% The average spectrum over masked ROI
subplot(4,3,8);
maskedPower = power(:,mask);
meanPower = mean(maskedPower,2);
spectrumPlot( meanPower, f, 'Average CBF Spectrum (Masked)' )

%% Dominant frequencies per ROI image with FFT
subplot(4,3,9);
dominantFrequencyImage( domFreqs, 'Dominant Frequencies per ROI with FFT' );

%% Spectrum of ROI with maximal power
subplot(4,3,10);
[~, idx] = max(entropy(:));
[row,col] = ind2sub([size(power,2), size(power,3)], idx);
spectrumPlot( power(:,row,col), f, 'Max Activity Spectrum' )

%% Spectrum of ROI with maximal power over mask
subplot(4,3,11);
[~, idx] = max(entropy(:).*mask(:));
[row,col] = ind2sub([size(power,2), size(power,3)], idx);
spectrumPlot( power(:,row,col), f, 'Max Activity Spectrum (Masked)' )

%% Distribution of dominant frequencies with FFT
subplot(4,3,12);
maskedFreqs = domFreqs(mask);
histogram(maskedFreqs(maskedFreqs<45),100);
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Dominant Frequencies per ROI with FFT (Masked)}')

end

