function [ videoData ] = loadAndExtractVideo( videoPath )
%LOADANDEXTRACTVIDEO loads the video specified by the relative filepath
%'videopath' and extracts the contained frames in a 3D array videoData.

% Get video data
numFrames = get(VideoReader(videoPath), 'numberOfFrames');
v = VideoReader(videoPath);

% Extract all frames
frames = cell(1, numFrames);
for idx = 1:numFrames
    if(mod(idx,50)==1)
        disp(['Extracting frame ' num2str(idx) '/' num2str(numFrames)]);
    end    
    frames{idx} = readFrame(v);
end

% Construct 3D-array
videoData = cell2mat(frames);
videoData = reshape(cell2mat(frames),size(videoData,1),[],numFrames);

end

