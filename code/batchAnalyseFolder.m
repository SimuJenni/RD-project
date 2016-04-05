function batchAnalyseFolder( folderPath, fs, roiSize, resultsDir )
%BATCHANALYSEFOLDER Anlayses all files in the given folder dir using the
%specified parameters and saves the results to the folder resultsDir.

saveDir = [resultsDir 'ROI' num2str(roiSize) '/'];

% Check if save folder exists and create if not
if (~exist(saveDir,'dir'))
    mkdir(saveDir);
end

disp('========================================================');
disp(['Analysing files in folder: ' folderPath]);

POOL = parpool(4);
tic

% Get a list of all .mat files
FileList = dir([folderPath '*.mat']); 

% Analyse all the files
numFiles = length(FileList); 
parfor idx = 1:numFiles
    fileName = FileList(idx).name;
    disp(['Analysing file ' num2str(idx) '/' num2str(numFiles) ': '...
        fileName]);
    
    % Load the file
    file = load([folderPath fileName]);
    [ power, f, domFreqs ] = performFFT( file.data, fs, roiSize );

    disp('Generating plots...');
    fig = figure('visible', 'off');

    % Make and store activity image
    fftPowerImage(power, fileName, saveDir);
    
    % Frequency plots
    spectrumPlots( power, f, domFreqs,  fileName, saveDir )
    
    % Save
    filePath = [saveDir fileName '_Results.png'];
    saveas(gcf,filePath);
    close(fig);

end
disp(['DONE! Runtime: ' num2str(toc)])
delete(POOL);

end

