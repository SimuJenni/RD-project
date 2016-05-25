function batchAnalyseFolder( folderPath, fs, roiSize, resultsDir,...
    preProcess, transformToUse, waveletType )
%BATCHANALYSEFOLDER Anlayses all files in the given folder using the
%specified parameters and saves the results to the folder resultsDir.
% Input:
%   folderPath - Relative path to folder of files to be analysed.
%   fs - Sampling frequency of the data to be analysed
%   roiSize - Size of the region of interes (ROI)
%   resultsDir - Path to directory where results should be stored
%   preProcess - Function handle for pre-processing function of extracted
%                data
%   transformToUse - Perform analysis with: fft, wt, or both. It WT or both is a parameter,
%                    waveletType parameter can be specified (morl by default)
%   waveletType - Specifies which wavelet to use for the wavelet transform (see WTAnalysis for more details)

% Check input
transformToUse = lower(transformToUse);

if ~strmatch(transformToUse, ['fft' 'wt' 'both'])
    error('Input ERROR: Expected transformToUse to be "fft" or "wt" or "both"')
end
if ~strcmp(transformToUse, 'fft')
    if nargin < 7
        waveletType = 'morl';
    end
    saveDirWT = [resultsDir 'WT/ROI ' num2str(roiSize) '/']; % save directory for wavelet transform
    % Check if save folders exists and create if not
    if (~exist(saveDirWT,'dir'))
        mkdir(saveDirWT);
    end
end
if ~strcmp(transformToUse, 'wt')
    saveDir = [resultsDir 'FFT/ROI ' num2str(roiSize) '/'];
    % Check if save folders exists and create if not
    if (~exist(saveDir,'dir'))
        mkdir(saveDir);
    end
end

disp('========================================================');
disp(['Analysing files in folder: ' folderPath]);

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
    
    % Preprocessing
    file.data = preProcess(file.data);
    
    if roiSize~=1
        % Downsample data before fft
        file.data = downSampleRoi(file.data, roiSize);
    end

    if ~strcmp(transformToUse, 'wt')
        disp('Error error')
        % analysis with FFT
        disp('Computing FFT...')
        [ power, f, domFreqs, domPhase ] = performFFT( file.data, fs );
        disp('Finished computing FFT.')

        % Plotting
        disp('Generating plots...');
        fig = figure( 'Position', [100, 100, 1024, 700]);
        activity = plotResults( file.data, power, f, domFreqs, 'fft' );

        % Save plots
        filePath = [saveDir fileName '_Results.png'];
        set(gcf,'PaperPositionMode','auto')
        print(filePath,'-dpng','-r0')
        close(fig);

        % Save data
        fileName = [saveDir fileName];
        parsave(fileName, power, f, domFreqs, domPhase, activity, []); % No activityWT for FFT
    end

    if ~strcmp(transformToUse, 'fft')
        % analysis with WT
        disp('Computing WT... (this operation can take a few minutes)')
        [ activityWT, powerWT, fWT, domFreqsWT ] = WTAnalysis( file.data, fs, waveletType);
        disp('Finished computing WT.')

        % Plotting
        disp('Generating plots...');
        fig = figure( 'Position', [100, 100, 1024, 700]);
        activity = plotResults( file.data, powerWT, fWT, domFreqsWT, 'wt', activityWT );

        % Save plots
        fileName = FileList(idx).name;
        filePath = [saveDirWT fileName '_Results.png'];
        set(gcf,'PaperPositionMode','auto')
        print(filePath,'-dpng','-r0')
        close(fig);

        domPhaseWT = []; % Not implemented yet

        % Save data
        fileName = [saveDirWT fileName];
        parsave(fileName, powerWT, fWT, domFreqsWT, domPhaseWT, activity, activityWT);
    end


    
end
disp(['DONE! Runtime: ' num2str(toc)])

end

function parsave(fname, fftPower, freqs, dominantFreqs, dominantPhase, activity, activityWT)
    save(fname, 'fftPower', 'freqs', 'dominantFreqs', 'dominantPhase', 'activity', 'activityWT')
end



