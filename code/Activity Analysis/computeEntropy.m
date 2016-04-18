function entropy = computeEntropy(data) 
%COMPUTEENTROPY Computes pixel-wise entropy of the provided video-data.

% Initialize empty array that will contain the pixel-wise entropy
entropy = zeros(size(data, 1),size(data, 2));

data = single(data);
disp('Computing Entropy...')

% Compute entropy pixel-wise
for row = 1:size(data, 1)
    for col = 1:size(data, 2)
        xh = histcounts(data(row,col,:));
        xh = xh / sum(xh(:));    % Compute probabilities
        idx = find(xh);           
        entropy(row,col) = -sum(xh(idx) .* log2(xh(idx)));  % Compute entropy
    end
end
disp('Finished computing entropy!') 
end

