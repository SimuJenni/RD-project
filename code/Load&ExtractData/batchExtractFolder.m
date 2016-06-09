function batchExtractFolder( extractFolder, storeFolder, reload )
%BATCHEXTRACTFOLDER Extracts data of all the videos in the folder 
%extractFolder (including subfolders) and saves it to storeFolder for later 
%analysis. Note that if reload is set to false and the video has already 
%been extracted, the video will not be extracted again.
% Input:
%   folderPath - String indicating the path of the video-data
%   storeFolder - Folder where the extracted data should be stored
%   reload - Boolean value (already extracted videos skipped if false)
% See also EXTRACTVIDEODATA, SAVEEXTRACTEDDATA and ALREADYEXTRACTED.

disp('========================================================');
disp(['Processing folder: ' extractFolder]);

% Get a list of all .avi files
FileList = dir([extractFolder '*.avi']); 

% Extract data from all the videos
numVideos = length(FileList); 
parfor idx = 1:numVideos
    videoPath = [extractFolder FileList(idx).name];
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
dirData = dir(extractFolder);
subDirs = {dirData([dirData.isdir]).name};  
validSubDirs = subDirs(~ismember(subDirs,{'.','..'})); 

% Process the subfolders
for idx = 1:length(validSubDirs)
    subFolder = [extractFolder validSubDirs{idx} '/'];
    batchExtractFolder( subFolder, storeFolder, reload );
end

end