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

%% Distribution of dominant frequencies
fig = figure('visible', 'off');
histogram(domFreqs(domFreqs<46),100);
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Distribution of dominant frequencies}')

% Save
filePath = [saveDir fileName '_Freq_Dist.png'];
saveas(gcf,filePath);
close(fig)


end

