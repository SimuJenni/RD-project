setup;

%% Demo for loading and extraction of video data

batchProcessFolder( videoDir, extractedDir, false );

%% Small demo on using the FFT

fileName = 'Cylia_beating_movie.mat';
load([extractedDir fileName]);
[ power, f, domFreqs ] = performFFT( data, fs, 1 );

% The activity image
fftPowerImage(power, fileName, resultsDir);

% Example plots
figure
plot(f(2:end/2),power(2:end/2,1,1))
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf CBF Spectrum}')

figure
histogram(domFreqs(:),100)
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Distribution of dominant frequencies}')

