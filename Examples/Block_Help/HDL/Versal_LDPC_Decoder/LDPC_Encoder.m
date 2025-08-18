%% LDPC Encoder

%-------------------
% Parameters
%-------------------
R = 1/3;                       % Code rate
numFrames = 1;                 % Number of frames to encode (number of code words)

H = dvbs2ldpc(R);              % DVB-S2 standard LDPC parity-check matrix
cfgEnc = ldpcEncoderConfig(H); % Encoder configuration


codewordLen = size(H, 2);      
numParityBits = size(H, 1);
numInfoBits = cfgEnc.NumInformationBits;

fprintf('LDPC Encoder configured:\n');
fprintf('  Code rate: %.2f\n', R);
fprintf('  Frame size: %d bits\n', codewordLen);
fprintf('  Information bits: %d\n', numInfoBits);

%-------------------
% Initialization
%-------------------
encodedFrames = cell(numFrames,1);
InputSymbols = [];
infoBits = [];

Sequence_Selection = 0; % Information bit-sequence selection

for i = 1:numFrames

% Information bits selection
if(Sequence_Selection == 1) % PN sequence selection

pn = comm.PNSequence('Polynomial', [1 0 0 0 1], ...
                     'InitialConditions', [1 0 0 1], ...
                     'SamplesPerFrame', numInfoBits);
infoBits = pn();

else   % Custom sequence selection

pattern = [1; 1; 1; 1; 0; 0; 0; 0]; 
infoBits = repmat(pattern, ceil(numInfoBits/length(pattern)), 1);
infoBits = infoBits(1:numInfoBits);  % Trim to exact size

end

% Encode LDPC
encodedBits = ldpcEncode(infoBits, cfgEnc);

% BPSK Modulation (0 → +1, 1 → -1)
modSignal = 1 - 2 * encodedBits;

% Add AWGN noise
EbN0dB = 20;       % Eb/N0
R = 1/3;           % code rate
M = 2;             % BPSK
snr = EbN0dB + 10*log10(R*log2(M));
rxSignal = awgn(modSignal, snr, 'measured');

% Generate soft LLR values
llr = -2 * rxSignal;

encodedFrames{i} = encodedBits;
InputSymbols = [InputSymbols; llr];
    
end

tlast = [zeros(1,64799),1,zeros(1,64799),1];
FrameNum = [zeros(1,64800),zeros(1,64800)];

