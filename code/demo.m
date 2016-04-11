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
