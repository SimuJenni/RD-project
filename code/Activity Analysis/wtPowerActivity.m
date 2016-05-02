function activity = wtPowerActivity( data )

activity = zeros(size(data, 1), size(data, 2));
sig = {};
sig{2} = 1/90;

disp('Computing activity with WT');

for i=1:size(data, 1)
    for j = 1:size(data, 2)
        sig{1} = single(data(i, j, :));
        contWavTrans = cwtft(sig);
        activity(i, j) = abs(contWavTrans.meanSIG);
    end
end

disp('Finished computing activity');

h = fspecial('gaussian', 3, 1);
activity = imfilter(squeeze(activity), h);

end