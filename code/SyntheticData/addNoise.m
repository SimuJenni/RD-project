function [ noisyData ] = addNoise( synthData, snr )
%ADDNOISE adds white noise to the provided synthetic data.
% Input:
%   synthData - the synthetic data without noise (width x height x frames)
%   snr - parameter specifying the signal to noise ratio
% Output:
%   noisyData - the noisy sythetic data

% Create a 2d-cell array of signals all the signals
signals = num2cell(synthData,3);

% Add white-noise to each signal
% awgn adds white gaussian noise to signal, squeeze removes singleton dimensions of x
noiseFun = @(x) permute(awgn(squeeze(x),snr),[2,3,1]);
noisySignals = cellfun(noiseFun, signals, 'UniformOutput', false);

% Convert back to ordinary array
noisyData = cell2mat(noisySignals);

end

