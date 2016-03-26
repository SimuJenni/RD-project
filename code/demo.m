clearvars;

addpath(genpath('./'));

% Check if data folders exist and create if not
if (~exist('./data','dir'))
    mkdir('./data');
end

% Directory where videos are stored
videoDir = 'data/';

batchProcessFolder( videoDir, 'extracted_data/', false );

%% Test synthetic examples
oscFun = simpleSine;
dim = [300,300,2];
freqs = 1:2:50;
amps = 0.1:0.1:1;
phases = 0:0.1:pi;
density = 1;
synthData = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

writeSynthVideo(synthData, 'synthClean' );

noisyData = addNoise( synthData, 0.5 );

writeSynthVideo(noisyData, 'synthDirty' );


%% Small demo on using the FFT

[ power, f, domFreqs ] = performFFT( noisyData, 90, 1 );

% Example plots
figure
plot(f(2:end/2),power(2:end/2,1,1))
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf CBF Spectrum}')

figure
histogram(domFreqs(:),m/4)
xlabel('Frequency (Hz)')
ylabel('Count')
title('{\bf Distribution of dominant frequencies}')

