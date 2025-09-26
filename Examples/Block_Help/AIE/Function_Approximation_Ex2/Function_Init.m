clc;
clear all;
N = 256; % Number of coarse points (2^TP_COARSE_BITS)
max_val = (2^15)-1; % Scaling for int16 (32767)
x = (0:N-1) / N; % Normalized domain points from 0 to 1
x_rad = x * 2 * pi; % Convert normalized domain to radians [0, 2pi]

y = sin(x_rad); % Evaluate sin(x) at each point

% Pre-allocate arrays
Slope1 = zeros(1, N);
Offset1 = zeros(1, N);

for i = 1:N-1
    Slope1(i) = y(i+1) - y(i); % Difference between adjacent points (point-slope form)
    Offset1(i) = y(i);          % Offset is value at point i
end

% Scale slope and offset to int16 range
Slope1_int16 = int16(Slope1*max_val);
Offset1_int16 = int16(Offset1*max_val);

% Combine slope and offset into a single LUT array [slope0, offset0, slope1, offset1, ...]
LUTValues = zeros(1, 2*N,'int16');
LUTValues(1:2:end) = Slope1_int16;
LUTValues(2:2:end) = Offset1_int16;
