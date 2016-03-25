addpath(genpath('./'));

% Check if data folders exist and create if not
if (~exist('./data','dir'))
    mkdir('./data');
end

% Use as an example video
videoDir = 'Data/';

[ videos ] = batchProcessFolder( videoDir );

%% Test synthetic examples

shapeFun = @(freq, amp, phase, t) amp*sin(2*pi*freq*t+phase);

generatedOscilations = generateSyntheticData( shapeFun, [300,300,1], ...
    (30), (0.1:0.1:1), (0.1:0.1:pi), 1 );

v = VideoWriter('synthTest.avi','Uncompressed AVI');
open(v);

for i=1:size(generatedOscilations,3)
    writeVideo(v,mat2gray(generatedOscilations(:,:,i)));
end
close(v);


%% Small demo on using the FFT

L = 90;
Fs = 90;
dataForFFT = permute(generatedOscilations,[3,1,2]);
Y = fft(dataForFFT);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

