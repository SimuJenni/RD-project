setup;

%% Script for running the speed tests

tic
batchExtractFolder( videoDir, extractedDir, false );
disp(['Extraction DONE! Runtime: ' num2str(toc)])

% Setting up de-noising parameters
% Standard denoising for testing
filterDims = [3, 3, 3];     % diemensions of 3d gaussian kernel
sigmas = [0.3, 0.3, 0.5];   % parameters for gaussians
denoise = @(x) filter3d(x, filterDims, sigmas);

% 77 videos in folder, each of them last 5 sec.
% roiSize = 1;
% tic
% batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir, denoise , 'fft' )
% timeFFTRoi1 = toc;
% meanTimePerVideoFFTRoi1 = timeFFTRoi1 / 77;
% disp(['Finished analyzing folder with FFT and ROI 1 in: ' num2str(timeFFTRoi1)])
% tic
% batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir, denoise , 'wt' )
% timeWTRoi1 = toc;
% meanTimePerVideoWTRoi1 = timeWTRoi1 / 77;
% disp(['Finished analyzing folder with WT and ROI 1 in: ' num2str(timeWTRoi1)])
%
% roiSize = [3 4];
% tic
% batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir, denoise , 'fft' )
% timeFFTRoi34 = toc;
% meanTimePerVideoFFTRoi34 = timeFFTRoi34 / 77;
% disp(['Finished analyzing folder with FFT and ROI [3 4] in: ' num2str(timeFFTRoi34)])
% tic
% batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir, denoise , 'wt' )
% timeWTRoi34 = toc;
% meanTimePerVideoWTRoi34 = timeWTRoi34 / 77;
% disp(['Finished analyzing folder with WT and ROI [3 4] in: ' num2str(timeWTRoi34)])

roiSize = [6 8];
% tic
% batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir, denoise , 'fft' )
% timeFFTRoi68 = toc;
% meanTimePerVideoFFTRoi68 = timeFFTRoi68 / 77;
% disp(['Finished analyzing folder with FFT and ROI [6 8] in: ' num2str(timeFFTRoi68)])
tic
batchAnalyseFolder( extractedDir, fs, roiSize, resultsDir, denoise , 'wt' )
timeWTRoi68 = toc;
meanTimePerVideoWTRoi68 = timeWTRoi68 / 77;
disp(['Finished analyzing folder with WT and ROI [6 8] in: ' num2str(timeWTRoi68)])

% write results to .dat file in folder ../doc/final_paper/speed_results.dat
Name = {'FFT';'WT'};
% ROI1 = [meanTimePerVideoFFTRoi1 ; meanTimePerVideoWTRoi1];
% ROI34 = [meanTimePerVideoFFTRoi34 ; meanTimePerVideoWTRoi34];
ROI68 = [meanTimePerVideoFFTRoi68 ; meanTimePerVideoWTRoi68];
T = table(ROI68,'RowNames',Name);
writetable(T, '../doc/final_paper/speed_results.dat', 'Delimiter','\t', 'WriteRowNames',true);