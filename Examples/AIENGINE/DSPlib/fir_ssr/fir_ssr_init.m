%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2025 Advanced Micro Devices, Inc.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
% http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% fir_ssr initialization

% Design parameters
N = 8192; % Frame size
SSR = 4; 
SHIFT_ACC = 15; % Shift FIR output by 2^-15
PLIO_FREQ = 500; % Transfer 2 cint16 samples per cycle = 1 GSPS throughput

% Generate filter coefficients
UTaps = CreateFilter(32);
Taps = NormalizeCoef(UTaps,32768); % Normalize the taps to fit in int16 data type

