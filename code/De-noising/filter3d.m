function [ data ] = filter3d( data, dims, sigmas, type )
%FILTER3D Filters the provided 3D-array data with a 3D-gaussian kernel with
%dimensions specified in dims and gaussians with standard-deviations
%specified by sigmas. Filtering in 'time' can optionally be performed using
%median-filtering.
% Input:
%   data - 3D array (width x height x frames)
%   dims - Vector (hx, hy, hz) of filter dimensions
%   sigmas - Vector (sx, sy, sz) parameters for gaussian filters
%   type - 'gaussian' or 'median' defining type of 3rd dimension filter
% Output:
%   data - filtered input
% See also BATCHANALYSEFOLDER.

%% Check inputs

if length(dims) ~= 3 || length(sigmas) ~= 3
    error('Input ERROR: Expected arguments to be of length 3')
end

if nargin < 4
    type = 'gaussian';
elseif ~strcmp(type, 'gaussian') && ~strcmp(type, 'median')
    error('Input ERROR: Expected type to be "gaussian" or "median"')
end

%% Filtering

% Third dimension either gaussian or median
if strcmp(type, 'gaussian')
    g_z = fspecial('gaussian', [1, dims(3)], sigmas(3));
    g_z = reshape(g_z,[1 1 dims(3)]);
    data = convn(data, g_z, 'same');
else
    data = medfilt1(double(data),3,[],3);
end

% Filtering is seperable! Perform three 1D convolutions -> Faster
g_x = fspecial('gaussian', [1, dims(1)], sigmas(1));
g_y = fspecial('gaussian', [dims(2), 1], sigmas(2));

% Filter first two dimensions with gaussians
data = convn(data, g_x, 'same');
data = convn(data, g_y, 'same');

end

