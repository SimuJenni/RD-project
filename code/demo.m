% Check if data folders exist and create if not
if (~exist('./data','dir'))
    mkdir('./data');
end
if (~exist('./data/frames','dir'))
    mkdir('./data/frames');
end

% Use as an example video
videoPath = 'Data/Cylia_beating_movie.avi';

% Get video data
numFrames = get(VideoReader(videoPath), 'numberOfFrames');
v = VideoReader(videoPath);

for idx = 1:numFrames
    if(mod(idx,50)==1)
        disp(['Extracting frame ' num2str(idx) '/' num2str(numFrames)]);
    end
    
    % Extract frame
    frame = readFrame(v);

    % Save image
    imname = ['test_name' num2str(idx) '.png'];
    imPath = ['./data/frames/' imname];
    imwrite(frame,imPath);
end
