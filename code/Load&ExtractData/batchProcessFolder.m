function batchProcessFolder( folderPath, storeFolder, reload )
%BATCHPROCESSFOLDER Extracts and saves all data from all the videos in the 
%given folder (including subfolders).
% Input:
%   folderPath - String indicating the relative folder-path
%   storeFolder - Folder where the extracted data should be saved
%   reload - Boolean value (already extracted videos skipped if false)
% See also EXTRACTVIDEODATA, SAVEEXTRACTEDDATA and ALREADYEXTRACTED.

disp(['Processing folder: ' folderPath]);
disp('========================================================');

% Get a list of all .avi files
FileList = dir([folderPath '*.avi']); 

% Extract data from all the videos
numVideos = length(FileList); 
for idx = 1:numVideos
    videoPath = [folderPath FileList(idx).name];
    disp(['Processing video ' num2str(idx) '/' num2str(numVideos) ': '...
        videoPath]);
    % Check if data should be extracted
    if reload || ~alreadyExtracted( videoPath, storeFolder )
        videoData = extractVideoData( videoPath );
        saveExtractedData( videoData , videoPath, storeFolder );
    else 
        disp(['Video ' videoPath ' has already been extracted!']);
    end
end

% Get all valid sub-directories
dirData = dir(folderPath);
subDirs = {dirData([dirData.isdir]).name};  
validSubDirs = subDirs(~ismember(subDirs,{'.','..'})); 

% Process the subfolders
for idx = 1:length(validSubDirs)
    subFolder = [folderPath validSubDirs{idx} '/'];
    batchProcessFolder( subFolder, storeFolder, reload );
end

end