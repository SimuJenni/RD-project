setup;

%% Demo for loading and extraction of video data
tic
batchExtractFolder( videoDir, extractedDir, false );
disp(['Extraction DONE! Runtime: ' num2str(toc)])

%% Batch analysing folder

% Setting up de-noising parameters
filterDims = [3, 3, 3];     % diemensions of 3d gaussian kernel
sigmas = [0.3, 0.3, 0.5];   % parameters for gaussians
denoise = @(x) filter3d(x, filterDims, sigmas);

roiSize = 1;
% roiSize = [3, 4];
% roiSize = [6, 8];
batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir, denoise , 'fft')

%% Launching the GUI for interpretation of the results
gui

%% Demo using WT
load([extractedDir 'Cylia_beating_movie.mat'])
[ power, f, domFreqs ] = WTAnalysis( data, fs );

%% Demo using FFT
load([extractedDir 'Cylia_beating_movie.mat'])
[ power, f, domFreqs, domPhase ] = performFFT( data, fs );

%% Demo activity image
activity = activityFromPower( power );
% activity = computeEntropy( data );
generateActivityImage( activity, 'Entropy' );

%% Demo probable shape extraction
load([resultsDir 'FFT/ROI 1/Cylia_beating_movie.mat'])
shape = probableShapeFromData( dominantFreqs, dominantPhase, data, activity, fs );