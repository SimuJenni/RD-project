setup;

% Check if test-data already exists and create if not
if (~exist([extractedDir 'synthClean.mat'],'file'))
    generateTestData;
end
load([extractedDir 'synthClean.mat']);

[ power, f, domFreqs ] = performFFT( data, fs, 1 );

% Test 1st block frequency 10Hz
assert(sum(find(abs(domFreqs(1:end/2,1:end/2)-10)>1))==0)

% Test 4th block frequency 15Hz or 0Hz
not15 = abs(domFreqs(end/2+1:end,end/2+1:end)-15)>1;
not0 = abs(domFreqs(end/2+1:end,end/2+1:end))>1;
assert(sum(find(not15&not0))==0);

% Plot distribution
figure
histogram(domFreqs(:),100)
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Distribution of dominant frequencies}')
