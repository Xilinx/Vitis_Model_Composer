%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2020 Xilinx
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

load mriBrainSlices;
num_slices = 10;
MRIDemo_data_real_frames = real(mriBrainSlices(:,:,45:55));
MRIDemo_data_real_channel = [];
for i=1:num_slices
    channel_data = MRIDemo_data_real_frames(:,:,i);
    channel_data = channel_data';
    channel_data = channel_data(:);
    MRIDemo_data_real_channel = [MRIDemo_data_real_channel;channel_data];
end

MRIDemo_data_imag_channel = [];
sysgenMRIDemo_data_imag_frames = imag(mriBrainSlices(:,:,45:55));
for i=1:num_slices
    channel_data = sysgenMRIDemo_data_imag_frames(:,:,i);
    channel_data = channel_data';
    channel_data = channel_data(:);
    MRIDemo_data_imag_channel = [MRIDemo_data_imag_channel;channel_data];
end

[c_image_rows, c_image_cols] = size(mriBrainSlices(:,:,1));
h = imagesc(log2(fftshift(abs(mriBrainSlices(:,:,50)))));
set(get(get(h,'parent'),'parent'),'name','Input K-space Data');
c_swathe_size = 1;
c_block_size = 64;
c_num_fstores = 16;
c_word_size = 8;
clear channel_data;
clear mriBrainSlices;
clear sysgenMRIDemo_data_imag_frames;
clear sysgenMRIDemo_data_real_frames;
