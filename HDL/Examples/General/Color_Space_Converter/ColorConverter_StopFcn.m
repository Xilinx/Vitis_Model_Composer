
if (exist('ySignal','var') & exist('NPixels','var'))

  if ((~isempty(ySignal)))

    designLatency = find(ySignal>0 & ySignal<1024);
    if (isempty(designLatency))
      return;
    end
    designLatency = designLatency(1);

    imageSize = size(ySignal);

    if (imageSize(1) >= designLatency+NPixels-1)

      % The initial output of the design (pipeline stages)
      % will be zeros and NaNs.
      % For plotting, we just assume that the first non-zero, non-NaN
      % output is the represents the first pixel.
      h = figure;
      clf;
      set(h,'Name','  Color Conversion Results');
      set(h,'Position',[100 50 1000 800]);

      ySignalN = ySignal(designLatency:designLatency+NPixels-1);
      ySignalN = ySignalN - (min(ySignalN));
      ySignalN = ySignalN / (max(ySignalN));

      subplot(2,3,2);
      image(ColorConverter_imageData), ...
        axis equal, axis square, axis off, title 'Original Image';

      subplot(2,3,4);
      image(reshape([ySignalN ySignalN ySignalN], ...
                    sqrt(NPixels),sqrt(NPixels),3)), ...
          axis equal, axis square, axis off, title 'Y Component';


      prSignalN = prSignal(designLatency:designLatency+NPixels-1);
      prSignalN = prSignalN - (min(prSignalN));
      prSignalN = prSignalN / (max(prSignalN));
      subplot(2,3,5);
      image(reshape([prSignalN prSignalN prSignalN], ...
                    sqrt(NPixels),sqrt(NPixels),3)), ...
          axis equal, axis square, axis off, title 'PR Component';


      pbSignalN = pbSignal(designLatency:designLatency+NPixels-1);
      pbSignalN = pbSignalN - (min(pbSignalN));
      pbSignalN = pbSignalN / (max(pbSignalN));
      subplot(2,3,6);
      image(reshape([pbSignalN pbSignalN pbSignalN], ...
                    sqrt(NPixels),sqrt(NPixels),3)), ...
          axis equal, axis square, axis off, title 'PB Component';
    end
  end
end

