%% Setup code before running anything comes here
clearvars;
addpath(genpath('./'));

%% Global variables

fs = 90;    % Sampling frequency

% Data directories
videoDir = './data/';
extractedDir = './extracted_data/';

% Check if data folder exists and create if not
if (~exist(videoDir,'dir'))
    mkdir(videoDir);
end
if (~exist(extractedDir,'dir'))
    mkdir(extractedDir);
end