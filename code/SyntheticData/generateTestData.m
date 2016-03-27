setup;

%% Generate synthetic examples

% Generate a 2x2 block test data of 240x320 blocks using simple sine-waves
oscFun = simpleSine;
dim = [240,320,3];

% 1st block (Freq:10 Hz, amp:1, phase:0, density:1)
freqs = 10;
amps = 1;
phases = 0;
density = 1;
block1 = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

% 2nd block (Freq:5-15 Hz, amp:0.5, phase:0-pi, density=1)
freqs = 5:0.1:15;
amps = 0.5;
phases = 0:0.1:pi;
density = 1;
block2 = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

% 3nd block (Freq:0-30 Hz, amp:0-1, phase:0.5*pi, density=0.5)
freqs = 0:0.2:30;
amps = 0:0.1:1;
phases = 0.5*pi;
density = 0.5;
block3 = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

% 4th block (Freq:15 Hz, amp:0.5-1, phase:0-pi, density=0.8)
freqs = 15;
amps = 0.5:0.05:1;
phases = 0:0.1:pi;
density = 0.8;
block4 = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

% Combine blocks
synthData = [block1, block2;
             block3, block4];
writeSynthVideo(synthData, 'synthClean' );

% Noisy version
noisyData = addNoise( synthData, 0.5 );
writeSynthVideo(noisyData, 'synthDirty' );

batchProcessFolder( 'data/synthetic/', extractedDir, false );



