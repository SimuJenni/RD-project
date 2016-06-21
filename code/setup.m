%% Setup code before running anything comes here
%clearvars;
addpath(genpath('./'));

%% Global variables

fs = 90;    % Sampling frequency

% Data directories
videoDir = './data/';           % Directory where the video-data is stored
extractedDir = './extracted_data/';     % Where to store the extracted data
resultsDir = './results/';      % Where to store the results

% Check if data folder exists and create if not
if (~exist(videoDir,'dir'))
    mkdir(videoDir);
end
if (~exist(extractedDir,'dir'))
    mkdir(extractedDir);
end
if (~exist(resultsDir,'dir'))
    mkdir(resultsDir);
end