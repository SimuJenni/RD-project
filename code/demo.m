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
freqs = 5;
amps = 1;
phases = 0;
density = 1;
synthData = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

writeSynthVideo(synthData, 'synthClean' );

noisyData = addNoise( synthData, 0.5 );

writeSynthVideo(noisyData, 'synthDirty' );


%% Small demo on using the FFT

L = size(synthData,3);
Fs = 90;
dataForFFT = permute(synthData,[3,1,2]);
Y = fft(dataForFFT);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

