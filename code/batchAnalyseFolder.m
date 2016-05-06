function batchAnalyseFolder( folderPath, fs, roiSize, resultsDir,...
    preProcess )
%BATCHANALYSEFOLDER Anlayses all files in the given folder using the
%specified parameters and saves the results to the folder resultsDir.
% Input:
%   folderPath - Relative path to folder of files to be analysed.
%   fs - Sampling frequency of the data to be analysed
%   roiSize - Size of the region of interes (ROI)
%   resultsDir - Path to directory where results should be stored
%   preProcess - Function handle for pre-processing function of extracted
%                data

saveDir = [resultsDir 'ROI ' num2str(roiSize) '/'];

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
    
    % Preprocessing
    file.data = preProcess(file.data);
    
    if roiSize~=1
        % Downsample data before fft
        file.data = downSampleRoi(file.data, roiSize);
    end
    [ power, f, domFreqs ] = performFFT( file.data, fs, roiSize );

    % Plotting
    disp('Generating plots...');
    fig = figure( 'Position', [100, 100, 1024, 700]);
    activity = plotResults( file.data, power, f, domFreqs );
    
    % Save plots
    filePath = [saveDir fileName '_Results.png'];
    set(gcf,'PaperPositionMode','auto')
    print(filePath,'-dpng','-r0')
    close(fig);
    
    % Save data
    fileName = [saveDir fileName];
    parsave(fileName, power, f, domFreqs, activity);
    
end
disp(['DONE! Runtime: ' num2str(toc)])

end

function parsave(fname, fftPower, freqs, dominantFreqs, activity)
    save(fname, 'fftPower', 'freqs', 'dominantFreqs', 'activity')
end



