function batchAnalyseFolder( folderPath, fs, roiSize, resultsDir,...
    preProcess, method, waveletType )
%BATCHANALYSEFOLDER Anlayses all files in the given folder using the
%specified parameters and saves the results to the folder resultsDir.
% Input:
%   folderPath - Relative path to folder of files to be analysed.
%   fs - Sampling frequency of the data to be analysed
%   roiSize - Size of the region of interes (ROI)
%   resultsDir - Path to directory where results should be stored
%   preProcess - Function handle for pre-processing function of extracted
%                data
%   method - String indicating which method to use for analysis ("wt",
%            "fft" or "both")
%   waveletType - Specifies which wavelet to use for the wavelet transform 

if nargin < 7
    waveletType = 'morl';
end

% Check input
method = lower(method);
if ~strmatch(method, {'fft' 'wt' 'both'})
    error('Input ERROR: Expected method to be "fft" or "wt" or "both"')
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

    if strmatch(method, {'fft' 'both'})
        % analysis with FFT
        disp('Computing FFT...')
        [ power, freqs, domFreqs, domPhase ] = performFFT( file.data, fs );
        disp('Finished computing FFT.')


        % Save the results
        saveDir = [resultsDir 'FFT/ROI ' num2str(roiSize) '/'];
        fPath = [saveDir '/' fileName];
        saveResults(saveDir, fPath, file.data, power, freqs, domFreqs, domPhase)
    end

    if strmatch(method, {'wt' 'both'})
        % analysis with WT
        disp('Computing WT... (this operation can take a few minutes)')
        [ power, freqs, domFreqs ] = WTAnalysis( file.data, fs, waveletType);
        domPhase = []; % Not implemented yet
        disp('Finished computing WT.')
       
        % Save the results
        saveDir = [resultsDir 'WT/ROI ' num2str(roiSize) '/'];
        fPath = [saveDir '/' fileName];
        saveResults(saveDir, fPath, file.data, power, freqs, domFreqs, domPhase)
    end    
end
disp(['DONE! Runtime: ' num2str(toc)])


end

function saveResults(saveDir, fileName, data, power, freqs, ...
    dominantFreqs, dominantPhase)

    % Check if save folders exists and create if not
    if (~exist(saveDir,'dir'))
        mkdir(saveDir);
    end
    
    % Plots
    disp('Generating plots...');
    fig = figure( 'Position', [100, 100, 1024, 700]);
    activity = plotResults( data, power, freqs, dominantFreqs );

    % Save plots
    filePath = [fileName '_Results.png'];
    set(gcf,'PaperPositionMode','auto')
    print(filePath,'-dpng','-r0')
    close(fig);

    % Save data
    save(fileName, 'power', 'freqs', 'dominantFreqs', 'dominantPhase', 'activity')
end





