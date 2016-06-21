setup;

storeFolder = extractedDir; % Where the synthetic axamples are stored

%% Generate synthetic example 1

disp('Generating synthetic data...')

% Generate a 2x2 block test data of 240x320 blocks using simple sine-waves
oscFun = simpleSine;
dim = [240,320,3];

% 1st block (Freq:10 Hz, amp:1, phase:0, density:1)
freqs = randn(1, 240*320)+10.0;
amps = 1;
phases = -2;
density = 1;
block1 = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

% 2nd block (Freq:2-20 Hz, amp:0.5, phase:0-pi, density=1)
freqs = randn(1, 240*320)+10.0;
amps = 0.8;
phases = -1;
density = 1;
block2 = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

% 3nd block (Freq:20-40 Hz, amp:0-1, phase:1.5*pi, density=0.5)
freqs = randn(1, 240*320)+15.0;
amps = 0.6;
phases = 1;
density = 1;
block3 = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

% 4th block (Freq:15 Hz, amp:0.5-1, phase:0, density=0.8)
freqs = randn(1, 240*320)+15.0;
amps = 0.4;
phases = 2;
density = 1;
block4 = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

% Combine blocks
data = [block1, block2;
             block3, block4];
         
save(strcat(storeFolder, 'synth1Clean', '.mat'), 'data');

% Noisy version
disp('Add noise to data...')
data = addNoise( data, 0.5 );

save(strcat(storeFolder, 'synth1Noisy', '.mat'), 'data');

%% Generate synthetic example 2

% Only 1 block (Freq:10 Hz, amp:0.5-1, phase:0-pi, density:1)
disp('Generating synthetic data...')
dim = [480,640,3];
freqs = randn(1, 480*640)+10.0;
amps = 0.5:0.01:1;
phases = 0:0.001:2*pi;
density = 0.8;
data = makeSynthetic(oscFun, dim, freqs, amps, phases, density);

save(strcat(storeFolder, 'synth2Clean', '.mat'), 'data');

% Noisy version
disp('Add noise to data...')
data = addNoise( data, 0.5 );

save(strcat(storeFolder, 'synth2Noisy', '.mat'), 'data');
