function [ videoData ] = extractVideoData( videoPath )
%EXTRACTVIDEODATA Extracts data from video for processing.
% [ videoData ] = extractVideoData( videoPath )
% Input:
%   videoPath - Relative file-path to the video
% Output:
%   videoData - 3D-array (width x height x numFrames) conatining the
%               extracted data 
% See also BATCHEXTRACTFOLDER

% Get video data
numFrames = get(VideoReader(videoPath), 'numberOfFrames');
v = VideoReader(videoPath);

% Extract all frames
frames = cell(1, numFrames);
for idx = 1:numFrames 
    frame = readFrame(v);
    if size(frame,3)>1
        frames{idx} = rgb2gray(frame);
    else
        frames{idx} = frame;
    end
end

% Construct 3D-array
videoData = cell2mat(frames);
videoData = reshape(cell2mat(frames),size(videoData,1),[],numFrames);

% Subtract the mean image before saving (good for FFT)
videoData = subtractMean(videoData);

end

