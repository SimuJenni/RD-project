addpath(genpath('./'));

% Check if data folders exist and create if not
if (~exist('./data','dir'))
    mkdir('./data');
end

% Use as an example video
videoDir = 'Data/';

[ videos ] = batchProcessFolder( videoDir );

%% Test synthetic examples
oscFun = simpleSine;
dim = [300,300,2];
freqs = 2:1:30;
amps = 0.1:0.1:2;
phases = 0.1:0.1:pi;
density = 1;
synthData = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

v = VideoWriter('synthTest.avi','Uncompressed AVI');
open(v);
min_v = min(synthData(:));
max_v = max(synthData(:));
for i=1:size(synthData,3)
    writeVideo(v,mat2gray(synthData(:,:,i),[min_v, max_v]));
end
close(v);


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

