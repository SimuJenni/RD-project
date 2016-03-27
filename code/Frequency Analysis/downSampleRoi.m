function [ downsampled ] = downSampleRoi( data, roiSize )
%DOWNSAMPLEROI Perfoms downsampling by avaraging ROI.
% Input:
%   data - 3D-array of input video-data (width x height x frames)
%   roiSize - Integer specifying the ROI-size
% Output:
%   downSampled - Downsampled data

inDim = size(data);
outDim = [floor(inDim(1:2)/roiSize),inDim(3)];
downsampled = zeros(outDim);

% Construct logical array of filter positions
filtPos = false(inDim(1:2));
d = ceil(roiSize/2);
filtPos(d:roiSize:end,d:roiSize:end) = true;

% Used filter
h = fspecial('average', roiSize);

% Iterate over all frames
for i=1:inDim(3)
    % Filter and extract relevant locations
    filtered = roifilt2(h, data(:,:,i), filtPos);
    downsampled(:,:,i) = filtered(d:roiSize:end,d:roiSize:end);
end

end

