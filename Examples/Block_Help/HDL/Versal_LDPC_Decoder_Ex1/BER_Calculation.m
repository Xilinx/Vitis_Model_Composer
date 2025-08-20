% Bit Error Rate(BER) Computation Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

totalBits = numel(infoBits); % Total number of information bits
byteArray = uint8(out.DecodedBytes);  
bitMatrix = de2bi(byteArray,8,'right-msb');  % LSB-first ordering

% Reshape into a bit stream
DecoderbitStream = reshape(bitMatrix.', [], 1);

numErrors = sum(infoBits ~= DecoderbitStream); % Number of bits in error

% Calculate BER

BER_HDL = numErrors / totalBits; % Versal LDPC Decoder Bit Error Rate


