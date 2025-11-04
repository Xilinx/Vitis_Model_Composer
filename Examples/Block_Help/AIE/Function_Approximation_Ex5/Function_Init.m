N = 256; % Number of coarse points (2^TP_COARSE_BITS)
max_val = (2^15)-1; % Scaling for int16 (32767)
x = (0:N-1) / N; % Normalized domain points from 0 to 1
x_rad = x * 2 * pi; % Convert normalized domain to radians [0, 2pi]

y = sin(x_rad); % Evaluate sin(x) at each point

% Pre-allocate arrays
Slope1 = zeros(1, N);
Offset1 = zeros(1, N);

for i = 1:N-1
   Slope1(i) = (y(i+1) - y(i)) / (x(i+1)-x(i)); % Slope-offset values for floating-point types (slope-intercept):
   Offset1(i) = y(i) - (Slope1(i)*x(i));   
end

% Wrap around last point to make the function continuous
Slope1(N) = (y(1) - y(N)) / (1 - x(N)); % slope from last to first
Offset1(N) = y(N) - (Slope1(N) * x(N));

% Scaling of LUT values not required for float data type

% Combine slope and offset into a single LUT array [slope0, offset0, slope1, offset1, ...]
LUTValues = zeros(1, 2*N,'single');
LUTValues(1:2:end) = Slope1;
LUTValues(2:2:end) = Offset1;
