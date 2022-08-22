function f = xlFrameDisplay(frameIndex, data_real, data_imag, frameSize,frameNum)
f = 1;
persistent mri_samples;
if nargin == 0,
    mri_samples = [];
    return;
end;
if isempty(mri_samples),
    mri_samples = zeros(frameSize, 1);
end;
mri_samples(frameIndex+1) = complex(data_real, data_imag);
if (frameIndex == frameSize-1),
    figure(2)
    set(gcf,'Name', 'Output MRI Image','NumberTitle','off')
    subplottight(2,5,frameNum), imshow(abs(reshape(mri_samples,256,256)),[],'Border','tight');    
    title(['MRI Slice ' num2str(frameNum)]);
    mri_samples = [];
end;
function h = subplottight(n,m,i)
    [c,r] = ind2sub([m n], i);
    ax = subplot('Position', [(c-1)/m, 1-(r)/n, 1/m, 1/n])
    if(nargout > 0)
      h = ax;
end
