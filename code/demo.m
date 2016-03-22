addpath(genpath('./'));

% Check if data folders exist and create if not
if (~exist('./data','dir'))
    mkdir('./data');
end

% Use as an example video
videoDir = 'Data/';

[ videos ] = batchProcessFolder( videoDir );

%% Test synthetic examples

shapeFun = @(freq, amp, phase, time) amp*sin(2*pi*freq*time+phase);

generatedOscilations = generateSyntheticData( shapeFun, [300,300,1], ...
    (2:2:30), (0.1:0.1:2), (0.1:0.1:pi), 0.3 );

v = VideoWriter('synthTest.avi','Uncompressed AVI');
open(v);

for i=1:size(generatedOscilations,3)
    writeVideo(v,mat2gray(generatedOscilations(:,:,i)));
end
close(v);

