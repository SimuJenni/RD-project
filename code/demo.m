setup;

%% Demo for loading and extraction of video data

batchExtractFolder( videoDir, extractedDir, false );

%% Batch analysing folder
roiSize = 3;
batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir )

%% Small demo on using the FFT

fileName = 'Cylia_beating_movie.mat';
load([extractedDir fileName]);
[ power, f, domFreqs ] = performFFT( data, fs, roiSize );

% The activity image
fftPowerImage(power, fileName, resultsDir);

% Frequency plots
spectrumPlots( power, f, domFreqs,  fileName, resultsDir )
