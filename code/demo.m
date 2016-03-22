% Check if data folders exist and create if not
if (~exist('./data','dir'))
    mkdir('./data');
end

% Use as an example video
videoDir = 'Data/';

[ videos ] = batchProcessFolder( videoDir );