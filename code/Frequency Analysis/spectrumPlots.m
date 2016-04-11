function spectrumPlots( power, f, domFreqs,  fileName, saveDir )
%SPECTRUMPLOTS Gnererates and saves plots of the results of the frequency
%analysis using fft. Figures of the average spectrum and dustribution of
%the dominant frequencies are generated

%% The average spectrum
subplot(2,2,2);
meanPower = mean(mean(power,2),3);
plot(f(1:round(end/2)),meanPower(1:round(end/2),1,1))
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Average CBF Spectrum}')

%% Spectrum of ROI with maximal power
subplot(2,2,3);
[maxv, ~] = max(power);
[~, idx] = max(maxv(:));
[row,col] = ind2sub([size(power,2), size(power,3)], idx);
plot(f(1:round(end/2)),power(1:round(end/2),row,col))
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Max Activity Spectrum}')

%% Distribution of dominant frequencies
subplot(2,2,4);
histogram(domFreqs(domFreqs<46),100);
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Dominant Frequencies per ROI}')

end

