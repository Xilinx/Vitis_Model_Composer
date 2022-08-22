
% ColorConverter_imageData is a matrix loaded by the model from a .mat
% file before this script is run.

% We now separate out the red green and blue components from the image.

redSignal = ColorConverter_imageData(:,:,1);
greenSignal = ColorConverter_imageData(:,:,2);
blueSignal = ColorConverter_imageData(:,:,3);

NPixels = size(redSignal,1) * size(redSignal,2);

% turn them into vectors (they were arrays):

redSignal = reshape(redSignal,1,NPixels);
greenSignal = reshape(greenSignal,1,NPixels);
blueSignal = reshape(blueSignal,1,NPixels);

% insert a column of 'time values' in front -- the from workspace
% block expects time followed by data on every row of the input

redSignal = [ double(0:NPixels-1)'  double(redSignal)'];
greenSignal = [ double(0:NPixels-1)'  double(greenSignal)'];
blueSignal = [ double(0:NPixels-1)'  double(blueSignal)'];


