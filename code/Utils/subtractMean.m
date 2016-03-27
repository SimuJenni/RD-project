function [ centeredData ] = subtractMean( data )
%SUBTRACTMEAN Subtracts the mean-frame of 3D-array data (width x height x 
%frames) from each frame of data.

dataMean = uint8(mean(data,3));
centeredData = data - repmat(dataMean,[1,1,size(data,3)]);

end
