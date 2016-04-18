setup

% This script will generate denoised copies of all extracted data in
% testDir
testDir = extractedDir;

%% Test different parameters for denoising

dims = [3, 3, 3];           % filter dimensions
sigmas = [0.3, 0.3, 0.5];   % parameters for gaussians
denoise1 = @(x) filter3d(x, dims, sigmas);

dims = [3, 3, 3];           % filter dimensions
sigmas = [0.3, 0.3, 0.5];   % parameters for gaussians
denoise2 = @(x) filter3d(x, dims, sigmas, 'median');

dims = [3, 3, 3];           % filter dimensions
sigmas = [0.5, 0.5, 0.8];   % parameters for gaussians
denoise3 = @(x) filter3d(x, dims, sigmas);

dims = [3, 3, 3];           % filter dimensions
sigmas = [0.5, 0.5, 0.8];   % parameters for gaussians
denoise4 = @(x) filter3d(x, dims, sigmas, 'median');


% Get a list of all .mat files
FileList = dir([testDir '*.mat']); 
numFiles = length(FileList); 
for idx = 1:numFiles
    fileName = FileList(idx).name;
    
    % Load the file
    file = load([testDir fileName]);
    [~, videoId, ~] = fileparts([testDir fileName]);
    
    % Denoise and save 
    data = denoise1(file.data);
    save([testDir videoId '_dn1.mat'], 'data');
    
    data = denoise2(file.data);
    save([testDir videoId '_dn2.mat'], 'data');

    data = denoise3(file.data);
    save([testDir videoId '_dn3.mat'], 'data');
    
    data = denoise4(file.data);
    save([testDir videoId '_dn4.mat'], 'data');
end





