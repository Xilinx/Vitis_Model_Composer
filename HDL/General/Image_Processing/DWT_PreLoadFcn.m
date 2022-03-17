
% sysgenDWT_imageData is a matrix loaded by the model from a .mat
% file before this script is run.

% We now burst it into two sub images based on 'checker board ordering'.

stride = [1:2:(64*64)];
dither = bitand(bitshift( [0:(64*32-1)], -5) ,1);

b1Init = DWT_imageData( stride + dither );
b2Init = DWT_imageData( stride + not(dither) );

