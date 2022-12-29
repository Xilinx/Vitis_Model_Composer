%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2021-2022 Xilinx
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

%% SSR4 initialization

DISPLAY = 0;

setenv('SRC','./src');

% N is frame size.
N = 2048;
NPHASES = 4;

Norm = 32768;
i = sqrt(-1);
UTaps = CreateFilter(32);
Taps = NormalizeCoef(UTaps,32768);


if(DISPLAY==1)
fprintf('---------------------------------------------------------------------\n');
fprintf('Normalization Coef %8d --> Result %d\n\n',Norm,sum(IntCoef));
fprintf('Real Part     : %8d  ->  %8d\n',min(real(IntCoef)),max(real(IntCoef)));
fprintf('Imaginary Part: %8d  ->  %8d\n',min(imag(IntCoef)),max(imag(IntCoef)));
fprintf('---------------------------------------------------------------------\n\n\n');
Lspec = 2048;
freqz(Taps/(Norm/Lspec),Lspec,'whole');
end

SaveTaps(Taps,fullfile(getenv('SRC'),'FilterTaps.txt'));


SHIFT_ACC = 15;

phi_3 = fliplr(Taps(1:4:end));
phi_2 = fliplr(Taps(2:4:end));
phi_1 = fliplr(Taps(3:4:end));
phi_0 = fliplr(Taps(4:4:end));

%PLIO Frequency
PLIO_FREQ = 500;




