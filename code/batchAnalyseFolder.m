function batchAnalyseFolder( folderPath, fs, roiSize, resultsDir,...
    preProcess, method, waveletType )
%BATCHANALYSEFOLDER Anlayses all files in the given folder using the
%specified parameters and saves the results to the folder resultsDir.
% Input:
%   folderPath - Path to folder of exctracted video files to be analysed
%   fs - Sampling frequency of the data to be analysed
%   roiSize - Integer or vector [sx, sy] specifying the ROI-size
%   resultsDir - Path to directory where results should be stored
%   preProcess - Function handle for pre-processing function of extracted
%                data (e.g. denoising)
%   method - String indicating which method to use for analysis ("wt",
%            "fft" or "both")
%   waveletType - Specifies which wavelet to use for the wavelet transform.
%                 'morl' is used by default
% See also BATCHEXTRACTFOLDER, FILTER3D.

if nargin < 7
    waveletType = 'morl';
end

% Check input
method = lower(method);
if ~strmatch(method, {'fft' 'wt' 'both'})
    error('Input ERROR: Expected method to be "fft" or "wt" or "both"')
end

disp('========================================================');
disp(['Analysing folder: ' folderPath]);

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

    if strmatch(method, {'fft' 'both'})
        % analysis with FFT
        [ power, freqs, domFreqs, domPhase ] = performFFT( file.data, fs );

        % Save the results
        saveDir = [resultsDir 'FFT/ROI ' num2str(roiSize) '/'];
        fPath = [saveDir '/' fileName];
        activity = saveResults(saveDir, fPath, file.data, power, freqs,...
            domFreqs, domPhase);
        writeResults2File( resultsDir, fileName, roiSize, method, power,...
            freqs, domFreqs );
        
        if(roiSize==1)
            fig = figure();
            % Compute and save propable shape
            probableShapeFromData(domFreqs, domPhase, file.data, activity, fs);
            % Save plot
            print([fPath '_Shape.png'],'-dpng','-r0');
            close(fig);
        end
    end

    if strmatch(method, {'wt' 'both'})
        % analysis with WT
        [ power, freqs, domFreqs ] = WTAnalysis( file.data, fs, waveletType);
        domPhase = []; % Not implemented yet
       
        % Save the results
        saveDir = [resultsDir 'WT/ROI ' num2str(roiSize) '/'];
        fPath = [saveDir '/' fileName];
        saveResults(saveDir, fPath, file.data, power, freqs, domFreqs,...
            domPhase);
        writeResults2File( resultsDir, fileName, roiSize, method, power,...
            freqs, domFreqs );
    end    
end
disp(['DONE! Runtime: ' num2str(toc)])


end

function activity = saveResults(saveDir, fileName, data, power, freqs, ...
    dominantFreqs, dominantPhase)

    % Check if save folders exists and create if not
    if (~exist(saveDir,'dir'))
        mkdir(saveDir);
    end
    
    % Plots
    fig = figure( 'Position', [100, 100, 1024, 700]);
    activity = plotResults( data, power, freqs, dominantFreqs, dominantPhase );

    % Save plots
    filePath = [fileName '_Results.png'];
    set(gcf,'PaperPositionMode','auto')
    print(filePath,'-dpng','-r0')
    close(fig);

    % Save data
    save(fileName, 'power', 'freqs', 'dominantFreqs', 'dominantPhase', 'activity')
end





