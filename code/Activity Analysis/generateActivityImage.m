function generateActivityImage( power, fileName, saveDir, method)
%GENERATEACTIVITYIMAGE produces an activity image of the video using the method passed as an argument.
%Input:
%   power - Power of resulting discrete fourier transform
%   fileName - name of the file
%   saveDir - directory used to store the resulting image
%   method - method used to generate the activity image. Currently supported methods: 
%            1. Mean of the FFT
%            2. Max entropy

subplot(2,2,1);

if strcmp(method, 'meanFFT')
    % Compute the mean fft-power
    activity = mean(power,1);
    
    % Filter the result for better visualization
    h=fspecial('gaussian',3,1);
    activity = imfilter(squeeze(activity),h);
    
    % Display
    colormap jet
    imagesc(activity)
    title('{\bf Activity based on mean FFT-power}')
    colorbar
    
elseif strcmp(method, 'maxent')
    
    % Initialize empty array that will contain the pixel-wise entropy
    entropy = [];
    
    % Compute entropy pixel-wise
    for i = 1:size(power, 3)
        if (mod(i, 40) == 1) 
            fprintf(2, '.') 
        end
        p = hist(power(:,:,i), 506);
        entropy(:,i) = -sum(p.*log2(p+0.01))';
    end
    fprintf(2, ' Finished computing entropy. Generating activity image...\n')
    
    % Filter the result for better visualization
    h=fspecial('gaussian',3,1);
    entropy = imfilter(squeeze(entropy),h);
    
    colormap jet
    imagesc(entropy)
    title('{\bf Activity based on Maximum Entropy method}')
    colorbar
    
else
    disp('Wrong input for the method. Please use mean or maxent.');
    
end


end

