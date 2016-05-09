function spectrumPlot( power, f, titleText )
%SPECTRUMPLOTS Gnererates a plot of the results of the frequency
%analysis using fft. 

plot(f,power(:,1,1))
xlabel('Frequency (Hz)')
ylabel('Power')
title(titleText)

end

