function dataSaved = saveExtractedData( data , videoPath, storeFolder )
%SAVEEXTRACTEDDATA Saves extracted video-data for later analysis.
% The data is saved in the folder storeFolder using the video-name as
% identifier.
% Input:
%   data - A 3d-array containing the frames of the video
%   videoPath - The path of the original video (video-name used for saving)
%   storeFolder - Path to folder for storing
% Output:
%   dataSaved - Boolean indicating whether data succesfully saved

% Get name of file
[~, videoId, ~] = fileparts(videoPath);

%Check if storeFolder exists, otherwise create it
if (~exist(storeFolder, 'dir')) % folder does not exist
    disp(['Folder ' storeFolder ' does not exist yet. Creating it ...'])
    mkdir(storeFolder);
    disp('Folder created. Trying to save the data.')
    saveExtractedData(data, videoPath, storeFolder);  
else 
    savePath = strcat(storeFolder, videoId, '.mat');
    if exist(savePath, 'file')
        disp(strcat('File ', savePath,' already exists!'));
        dataSaved = false;
    else
        disp(['Saving data to: ' savePath]);
        save(savePath, 'data');
        dataSaved = true;
    end
end

end
    