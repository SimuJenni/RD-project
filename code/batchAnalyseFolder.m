function batchAnalyseFolder( folderPath, fs, roiSize, resultsDir )
%BATCHANALYSEFOLDER Anlayses all files in the given folder dir using the
%specified parameters and saves the results to the folder resultsDir.

disp('========================================================');
disp(['Analysing files in folder: ' folderPath]);

% POOL = parpool('local',2);
tic

% Get a list of all .mat files
FileList = dir([folderPath '*.mat']); 

% Analyse all the files
numFiles = length(FileList); 
for idx = 1:numFiles
    fileName = FileList(idx).name;
    disp(['Analysing file ' num2str(idx) '/' num2str(numFiles) ': '...
        fileName]);
    
    % Load the file
    file = load([folderPath fileName]);
    [ power, f, domFreqs ] = performFFT( file.data, fs, roiSize );

    disp('Generating plots...');

    % Make and store activity image
    fftPowerImage(power, fileName, resultsDir);
    
    % Frequency plots
    spectrumPlots( power, f, domFreqs,  fileName, resultsDir )
end
disp(['DONE! Runtime: ' num2str(toc)])
% delete(POOL);

end

