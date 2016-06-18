function entropy = plotResults( data, power, f, domFreqs, dominantPhase, fs)
%PLOTRESULTS Manages the creation of plots for all results.

%% Activity images first
% FFT or WT power
subplot(3,3,1);
generateActivityImage( activityFromPower(power), ['Activity: Power'] );

% Entropy
subplot(3,3,2);
entropy = computeEntropy(data);
generateActivityImage( entropy, 'Activity: Entropy' );

% The mask
subplot(3,3,3);
mask = activityMask( entropy, 0.25, 0.75 );
generateActivityImage( mask, 'Activity Mask' );

%% The average spectrum over masked ROI
subplot(3,3,4);
maskedPower = power(:,mask);
meanPower = mean(maskedPower,2);
spectrumPlot( meanPower, f, 'Average CBF Spectrum (Masked)' )

%% Image of dominant frequencies
subplot(3,3,5);
dominantFrequencyImage( domFreqs, 'Dominant Frequencies per ROI' );

%% Image of dominant phases
subplot(3,3,6);
dominantPhaseImage( dominantPhase, 'Dominant Phase per ROI' );

%% The average spectrum over all ROI
subplot(3,3,7);
meanPower = mean(power,2);
spectrumPlot( meanPower, f, 'Average CBF Spectrum (all ROI)' )

%% Distribution of dominant frequencies
subplot(3,3,8);
maskedFreqs = domFreqs(mask);
histogram(maskedFreqs(maskedFreqs<45),100);
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Dominant Frequencies per ROI (Masked)}')

%% Distribution of dominant phases
subplot(3,3,9);
maskedPhase = dominantPhase(mask);
histogram(maskedPhase,100);
xlabel('Phase (rad)')
ylabel('Count')
title('{\bf Dominant Phase per ROI (Masked)}')


end
