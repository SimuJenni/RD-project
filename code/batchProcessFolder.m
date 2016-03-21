function [ videos ] = batchProcessFolder( folderPath )
%Processes all the videos in the given folderPath including subfolders.
% Returns a cell-array videos where each entry is a 3D-array containing the
% video data extracted with loadAndExtractVideo()

disp(['Processing folder: ' folderPath]);
disp('========================================================');


% Get a list of all .avi files
FileList = dir([folderPath '*.avi']); 

% Extract data from all the videos
numVideos = length(FileList); 
videos = cell(1, numVideos);
for idx = 1:numVideos
    videoPath = [folderPath FileList(idx).name];
    disp(['Processing video ' num2str(idx) '/' num2str(numVideos) ': '...
        videoPath]);
    videos{idx} = loadAndExtractVideo( videoPath );
end

% Get all valid sub-directories
dirData = dir(folderPath);
subDirs = {dirData([dirData.isdir]).name};  
validSubDirs = subDirs(~ismember(subDirs,{'.','..'})); 

% Process the subfolders
for idx = 1:length(validSubDirs)
    subFolder = [folderPath validSubDirs{idx} '/'];
    newVids = batchProcessFolder( subFolder );
    videos = [videos, newVids]; % Append
end

end