load mriBrainSlices;
num_slices = 10;
MRIDemo_data_real_frames = real(mriBrainSlices(:,:,45:55));
MRIDemo_data_real_channel = [];
for i=1:num_slices,
    channel_data = MRIDemo_data_real_frames(:,:,i);
    channel_data = channel_data';
    channel_data = channel_data(:);
    MRIDemo_data_real_channel = [MRIDemo_data_real_channel;channel_data];
end;

MRIDemo_data_imag_channel = [];
MRIDemo_data_imag_frames = imag(mriBrainSlices(:,:,45:55));
for i=1:num_slices,
    channel_data = MRIDemo_data_imag_frames(:,:,i);
    channel_data = channel_data';
    channel_data = channel_data(:);
    MRIDemo_data_imag_channel = [MRIDemo_data_imag_channel;channel_data];
end;
[c_image_rows, c_image_cols] = size(mriBrainSlices(:,:,1));
%h = imagesc(log2(fftshift(abs(mriBrainSlices(:,:,50)))));
%set(get(get(h,'parent'),'parent'),'name','Input K-space Data');
c_swathe_size = 1;
c_block_size = 64;
c_num_fstores = 16;
c_word_size = 8;
clear channel_data;
clear mriBrainSlices;
clear sysgenMRIDemo_data_imag_frames;
clear sysgenMRIDemo_data_real_frames;

% configure hardware specifics information
clock_frequency = 150e6;
row_in = 256;
row_length_bits = log2(row_in);
col_in = 256;
col_length_bits = log2(col_in);
col_out = row_in;
corner_turn_memory_depth = log2(col_in * col_out);
read_ping_pong_set_point = col_in*col_out - 25;
