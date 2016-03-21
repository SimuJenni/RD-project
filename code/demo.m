% Check if data folders exist and create if not
if (~exist('./data','dir'))
    mkdir('./data');
end
if (~exist('./data/frames','dir'))
    mkdir('./data/frames');
end

% Use as an example video
videoDir = 'Data/';

[ videos ] = batchProcessFolder( videoDir );