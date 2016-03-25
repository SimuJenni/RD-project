function dataSaved = saveExtractedData( data , videoPath )
%Saves data (a 3d-array containing the frames of the video) to the file videoId.mat
%The data is saved in a subfolder "savedData" located in the same directory as videoPath

% Get path, name and extension of file
[videoDir, videoId, videoExt] = fileparts(videoPath);

%Check if savedData subfolder exists, otherwise create it
if (exist(strcat(videoDir, '/savedData/')) == 0) % folder does not exist
    disp('Folder savedData does not exist yet. Creating it ...')
    mkdir(videoDir, 'savedData');
    disp('Folder created. Trying to save the data.')
    saveExtractedData(data, videoPath);  
elseif (exist(strcat(videoDir, '/savedData/')) == 7) % folder already exists
    savePath = strcat(videoDir, '/savedData/', videoId, '.mat');
    disp(['Saving data to: ' savePath]);
    save(savePath, 'data');
    disp('Data saved.')
    dataSaved = true;
else % name exists but it is something else (this case should not happen)
    disp('Error, can not save the data');
    dataSaved = false;
end

end
    