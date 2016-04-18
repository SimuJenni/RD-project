setup;

%% Demo for loading and extraction of video data
POOL = parpool(2);
tic
batchExtractFolder( videoDir, extractedDir, false );
disp(['Extraction DONE! Runtime: ' num2str(toc)])

%% Batch analysing folder
roiSize = 3;
batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir )
delete(POOL);

% %% Demo using FFT
% load([extractedDir 'Cylia_beating_movie.mat'])
% [ power, f, domFreqs ] = performFFT( data, fs, 1 );
% 
% %% Demo activity image
% activity = fftPowerActivity( power );
% activity = computeEntropy( data );
% 
% generateActivityImage( activity, 'Entropy' );