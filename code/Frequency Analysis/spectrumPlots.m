function spectrumPlots( power, f, domFreqs,  fileName, saveDir )
%SPECTRUMPLOTS Gnererates and saves plots of the results of the frequency
%analysis using fft. Figures of the average spectrum and dustribution of
%the dominant frequencies are generated

%% The average spectrum
fig = figure('visible', 'off');
meanPower = mean(mean(power,2),3);
plot(f(1:round(end/2)),meanPower(1:round(end/2),1,1))
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Average CBF Spectrum}')

% Save
filePath = [saveDir fileName '_Avg_Spect.png'];
saveas(gcf,filePath);
close(fig)


%% Spectrum of ROI with maximal power
fig = figure('visible', 'off');
[maxv, ~] = max(power);
[~, idx] = max(maxv(:));
[row,col] = ind2sub([size(power,2), size(power,3)], idx);
plot(f(1:round(end/2)),power(1:round(end/2),row,col))
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf CBF Spectrum of ROI with Maximum FFT-Power}')

% Save
filePath = [saveDir fileName '_Max_Spect.png'];
saveas(gcf,filePath);
close(fig)

%% Distribution of dominant frequencies
fig = figure('visible', 'off');
histogram(domFreqs(domFreqs<46),100);
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Distribution of Dominant Frequencies per ROI}')

% Save
filePath = [saveDir fileName '_Freq_Dist.png'];
saveas(gcf,filePath);
close(fig)


end

