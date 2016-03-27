roiSize = 3;

% Setup test input
I = zeros(480,640);
for i=1:480
    for j=1:640
        I(i,j) = floor((i-1)/roiSize)+floor((j-1)/roiSize);
    end
end

% Expected Result
dim = floor(size(I)/roiSize);
E = zeros(dim);
for i=1:dim(1)
    for j=1:dim(2)
        E(i,j) = (i-1)+(j-1);
    end
end

% Downsample and test if equal
downSampled = downSampleRoi( I, roiSize );
assert(sum(find(abs(E-downSampled)>0.1))==0);