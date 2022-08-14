
%% Demonstration of the flow from Model Composer HLS to HDL
% This file will guide the reader thorough the flow of moving a Model
% Composer HLS design into HDL as a black box. 
%
% The file comprises the following sections:
% * Section 1. Set up.
% * Section 2. Creating a HDL solution from a Model Composer HLS design.
% * Section 3. Serializing the input video 
% * Section 4: Import the generated solution into HDL Design  
% * Section 5: Simulate the Model Composer HDL Design
% * Section 6: Deserializing the output of the HDL design
% * Section 7: Playing the deserialized output using MATLAB implay.

%% Section 1: Set up 
% Open MATLAB for Model Composer & Choose a video file as an input
video_filename = 'vipmen.avi';

v = VideoReader(video_filename);
frame_height = v.Height;
frame_width = v.Width;
save video_handle v

%% Section 2: Creating a HDL solution from a HLS design.
% model composer allows you to export a HLS design as a block into HDL. The result of
% exporting a design from Model Composer HLS to HDL is a 'solution' folder
% that you will import to the HDL design using Vitis HLS block in HDL Library.

% Execute the following commands in Model Composer, or open the
% MoC_design.slx, go to the compiler block and press 'Generate'. Creating a
% SysGen IP from a system in Model Composer may take several minutes.
open_system('HLS_design');
xmcGenerate('HLS_design');

%% Section 3: Serializing the input video

% Serialize the input video which is required for use with the Model Composer
% HDL design that will do pixel-based processing

stream_in = zeros(ceil(v.FrameRate*v.Duration*v.Height*v.Width),1);

i = 1;
while hasFrame(v)
    frame = rgb2gray(readFrame(v));
    a = reshape(frame',[],1);
    stream_in(i:i+length(a)-1) = a;
    i = i + length(a);
end

save stream_in stream_in


%% Section 4: Import the generated solution into HDL Design

% Open the Model Composer HDL model 
open_system('HDL_AXI');

% You need to point the Vitis HLS block to the right solution. 
% Click the Vitis HLS block and point it to the
% solution folder that got created in the last section which is :
%.\code_HLS\ModelComposerDesign_prj\solution1

%% Section 5: Simulate the Model Composer HDL Design

% Simulate the HDL model. The simulation will be slow. 
% At the end of the simulation, the output will be saved in the stream_out.mat file. 
sim('HDL_AXI');

%% Section 6: Deserializing the output of the HDL design. 

load stream_out
load video_handle

disp(['Length of input stream is ',num2str(length(stream_in))])
disp(['Lenght of output stream is ',num2str(length(stream_out))])


outputVideo = VideoWriter('stream_out.avi');
outputVideo.FrameRate = v.FrameRate;
open(outputVideo)

%The output is boolean. This is why we multiply the img by 255 so that
%implay shows the image. 
for i = 1:length(stream_out)/v.Height/v.Width
   img = reshape(stream_out((i-1)*v.Height*v.Width+1:i*v.Height*v.Width),v.Width,v.Height);
   writeVideo(outputVideo,255*img')
end

close(outputVideo);

%% Section 7: Playing the deserialized output using MATLAB implay.
implay('stream_out.avi')
% Click on Play button
