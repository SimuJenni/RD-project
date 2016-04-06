setup;

%% Demo for loading and extraction of video data
POOL = parpool(2);
tic
batchExtractFolder( videoDir, extractedDir, false );
disp(['Extraction DONE! Runtime: ' num2str(toc)])
delete(POOL);

%% Batch analysing folder
roiSize = 1;
batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir )

%% Small demo on using the FFT

fileName = 'Cylia_beating_movie.mat';
load([extractedDir fileName]);
[ power, f, domFreqs ] = performFFT( data, fs, roiSize );

% The activity image
fftPowerImage(power, fileName, resultsDir);

% Frequency plots
spectrumPlots( power, f, domFreqs,  fileName, resultsDir )
