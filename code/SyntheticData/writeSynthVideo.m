function writeSynthVideo( synthData, videoName )
%WRITESYNTHVIDEO Writes the data contained in synthData as video to 
%data/synthetic/ with the given name

% Check if folder exist and create if not
if (~exist('data/synthetic','dir'))
    mkdir('./data/synthetic');
end

v = VideoWriter(['./data/synthetic/' videoName '.avi'],'Uncompressed AVI');
open(v);
min_v = min(synthData(:));
max_v = max(synthData(:));
for i=1:size(synthData,3)
    writeVideo(v,mat2gray(synthData(:,:,i),[min_v, max_v]));
end
close(v);


end

