function [ data ] = subtractMean( data )
%SUBTRACTMEAN Subtracts the mean-frame of 3D-array data (width x height x 
%frames) from each frame of data.

data = single(data);
dataMean = single(mean(data,3));
data = data - repmat(dataMean,[1,1,size(data,3)]);

end
