function [ extracted ] = alreadyExtracted( videoPath, storeFolder )
%ALREADYEXTRACTED Checks if data from the video with specified path has
%already been etracted and saved to folder 'storeFolder'

% Get name of file
[~, videoId, ~] = fileparts(videoPath);
savePath = strcat(storeFolder, videoId, '.mat');
extracted = exist(savePath, 'file')>0;
end

