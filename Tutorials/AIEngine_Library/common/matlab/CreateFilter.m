% Copyright 2022-2023 Advanced Micro Devices, Inc.
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%

%% Half-Band Filter 1

Shift1 = 15;
K1 = 2^Shift1;
hb = HB1;
hb1 = NormalizeHBCoef(hb.Numerator,K1/2); % Decimation so K1/2
hb1((length(hb1)+1)/2) = K1/2;
hb1_aie = hb1([ 1:2:(length(hb1)-1)/2 (length(hb1)+1)/2]);

%% Half-Band Filter 2

Shift2 = 15;
K2 =2^Shift2;
hb = HB2;
hb2 = NormalizeHBCoef(hb.Numerator,K2/2);
hb2((length(hb2)+1)/2) = K2/2;
hb2_aie = hb2([ 1:2:(length(hb2)-1)/2 (length(hb2)+1)/2]);

%% Half-Band Filter 3

Shift3 = 15;
K3 =2^Shift3;
hb = HB3;
hb3 = NormalizeHBCoef(hb.Numerator,K3/2);
hb3((length(hb3)+1)/2) = K3/2;
hb3_aie = hb3([ 1:2:(length(hb3)-1)/2 (length(hb3)+1)/2]);

%% Channel Filter

ShiftCF = 15;
Kcf =2^ShiftCF;
cf = ChannelFilter;
cfi = NormalizeCoef(cf.Numerator,Kcf);
cfi_aie = cfi(1:(length(cfi)+1)/2);

