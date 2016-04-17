function [ pxx, f, domFreqs ] = performMaxEnt( data, order, fs, roiSize )

pxx = [];
m = size(data, 3);        % Window length
n = pow2(nextpow2(m));    % Next power of 2, for efficiency

if roiSize ~= 1
    % Downsample data before applying maximum entropy
    data = downSampleRoi(data, roiSize);
end

% Reorder the dimensions to have width x time x height
% (This does not seem to be a convention for the maxEnt method, however it 
%  facilitates the analysis as pyulear will treat the columns of the matrix)

data = single(permute(data, [3, 1, 2]));

for i = 1:size(data, 3)
    if (mod(i, 40) == 1) 
        fprintf(2, '.') 
    end
    [pxx(:,:,i), f] = pyulear(data(:,:,i), order, n, fs);
end

clear data;
f = f';
disp(size(f));

% Get index of dominant frequencies > 1Hz per ROI
validFreqs = find(f>1);
disp(size(validFreqs));
f = f(validFreqs);
disp(size(f));
disp(size(pxx));
pxx = pxx(validFreqs(:),:,:);
[~, domFreqsIdx] = max(pxx);

% Get pixel-wise dominant frequencies
domFreqs = f(domFreqsIdx);
domFreqs = squeeze(domFreqs);
end
