function [ downsampled ] = downSampleRoi( data, roiSize )
%DOWNSAMPLEROI Perfoms downsampling by avaraging data corresponding to the 
%specified ROI size.
% Input:
%   data - 3D-array of input video-data  of size (w x h x f)
%   roiSize - Integer or vector [sx, sy] specifying the ROI-size
% Output:
%   downSampled - Downsampled data of size (w/sy x h/sx x f)
% See also BATCHANALYSEFOLDER.

if isscalar(roiSize)
    roiSize = [roiSize roiSize];
end

inDim = size(data);
outDim = [floor(inDim(1:2)./roiSize),inDim(3)];
downsampled = zeros(outDim);

% Construct logical array of filter positions
filtPos = false(inDim(1:2));
d = ceil(roiSize/2);
filtPos(d(1):roiSize(1):end,d(2):roiSize(2):end) = true;

% Used filter
h = fspecial('average', roiSize);

% Iterate over all frames
for i=1:inDim(3)
    % Filter and extract relevant locations
    filtered = roifilt2(h, data(:,:,i), filtPos);
    downsampled(:,:,i) = filtered(d(1):roiSize(1):end,d(2):roiSize(2):end);
end

end

