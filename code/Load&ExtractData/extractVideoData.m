function [ videoData ] = extractVideoData( videoPath )
%EXTRACTVIDEODATA Extracts data from video for processing.
% [ videoData ] = extractVideoData( videoPath )
% Input:
%   videoPath - Relative file-path to the video
% Output:
%   videoData - 3D-array (width x height x numFrames) conatining the
%               extracted data 
% See also BATCHPROCESSFOLDER

% Get video data
numFrames = get(VideoReader(videoPath), 'numberOfFrames');
v = VideoReader(videoPath);

% Extract all frames
frames = cell(1, numFrames);
for idx = 1:numFrames
    if(mod(idx,50)==1)
        fprintf(2,'.');
    end    
    frames{idx} = readFrame(v);
end
disp('Done!');

% Construct 3D-array
videoData = cell2mat(frames);
videoData = reshape(cell2mat(frames),size(videoData,1),[],numFrames);

end

