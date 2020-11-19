load mri_data_brain_slices;
num_slices = 10;
start_slice = 45;

MRIDemo_data_real_frames = real(mriBrainSlices(:,:,start_slice:start_slice+num_slices-1));
MRIDemo_data_real_channel = [];

for i=1:num_slices
    channel_data = MRIDemo_data_real_frames(:,:,i)';
    channel_data = channel_data(:);
    MRIDemo_data_real_channel = [MRIDemo_data_real_channel;channel_data];
end

MRIDemo_data_imag_channel = [];
MRIDemo_data_imag_frames = imag(mriBrainSlices(:,:,start_slice:start_slice+num_slices-1));

for i=1:num_slices
    channel_data = MRIDemo_data_imag_frames(:,:,i);
    channel_data = channel_data';
    channel_data = channel_data(:);
    MRIDemo_data_imag_channel = [MRIDemo_data_imag_channel;channel_data];
end

[c_image_rows, c_image_cols] = size(mriBrainSlices(:,:,1));
%h = imagesc(log2(fftshift(abs(mriBrainSlices(:,:,50)))));
%set(get(get(h,'parent'),'parent'),'name','Input K-space Data');

c_swathe_size = 1;
c_block_size = 64;
c_num_fstores = 16;
c_word_size = 8;

clear channel_data;
clear mriBrainSlices;
clear MRIDemo_data_imag_frames;
clear MRIDemo_data_real_frames;