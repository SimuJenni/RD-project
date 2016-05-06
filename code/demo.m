setup;

%% Demo for loading and extraction of video data
POOL = parpool(2);
tic
batchExtractFolder( videoDir, extractedDir, false );
disp(['Extraction DONE! Runtime: ' num2str(toc)])

%% Batch analysing folder

% Setting up de-noising parameters
filterDims = [3, 3, 3];     % diemensions of 3d gaussian kernel
sigmas = [0.3, 0.3, 0.5];   % parameters for gaussians
denoise = @(x) filter3d(x, filterDims, sigmas);

roiSize = [3, 4];
% roiSize = [6, 8];
batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir, denoise )

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