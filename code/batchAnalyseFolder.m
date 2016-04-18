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
    
    if roiSize~=1
        % Downsample data before fft
        file.data = downSampleRoi(file.data, roiSize);
    end
    [ power, f, domFreqs ] = performFFT( file.data, fs, roiSize );

    % Plotting
    disp('Generating plots...');
    fig = figure( 'Position', [100, 100, 1024, 700]);
    plotResults( file.data, power, f, domFreqs )
    
    % Save
    filePath = [saveDir fileName '_Results.jpg'];
    set(gcf,'PaperPositionMode','auto')
    print(filePath,'-dpng','-r0')
    close(fig);
end
disp(['DONE! Runtime: ' num2str(toc)])

end


