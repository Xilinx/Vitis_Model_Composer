
if (exist('b1','var') & exist('b2','var'))
  if ((~isempty(b1)) & (~isempty(b2)))

    h = figure;
    clf;
    set(h,'Name','  DWT Results');
    ss = get(0,'ScreenSize');
    width = 0.80*ss(3);
    height = 0.80*ss(4);
    pos = [0.50*(ss(3)-width)  0.50*(ss(4)-height)  width  height];
    set(h,'Position',pos);
    %movegui(h,'onscreen');
    %movegui(h,'center');

    titles = {'Original Image\n ', ...
     'Raw Memory Image, after Phase 0\n(Phase 1 overwrite has begun)', ...
     'Raw Memory Image, after Phase 1\n(Phase 2 overwrite has begun)', ...
     'Raw Memory Image, after Phase 2\n(Phase 3 overwrite has begun)', ...
     'Raw Memory Image, Final State\n '};

    stride = [1:2:(64*64)];
    dither = bitand(bitshift( [0:(64*32-1)], -5) ,1);

    for i = 1:size(b1,3)

      imageVec( stride +     dither)  = b1(:,:,i);
      imageVec( stride + not(dither)) = b2(:,:,i);

      %   PaolinaDetail = reshape([b1(:,:,i); b2(:,:,i)], 64, 64);

      imageMat = reshape(imageVec, 64, 64);

      imageMat = imageMat - min(min(imageMat));
      imageMat = imageMat / max(max(imageMat));

      imageMat = [zeros(68,2) [zeros(2,64); imageMat; zeros(2,64)] zeros(68,2)];

      greyscaleImage = reshape([imageMat imageMat imageMat], ...
                               size(imageMat,1), size(imageMat,2), 3);

      subplot(2,3,i);
      image(greyscaleImage), axis square, axis equal, axis off, ...
          title(sprintf(titles{i}))
    end

    if (i==5)
      % simulation completed; build up composite image

      imageMat = reshape(imageVec, 64, 64);

      subImage{1} = imageMat(1:16,1:16);
      subImage{2} = imageMat(1:16,17:32);
      subImage{3} = imageMat(17:32,1:16);
      subImage{4} = imageMat(17:32,17:32);
      subImage{5} = imageMat(1:32,33:64);
      subImage{6} = imageMat(33:64,1:32);
      subImage{7} = imageMat(33:64,33:64);

      for i = 1:7
        subImage{i} = subImage{i} - min(min(subImage{i}));
        subImage{i} = subImage{i} / max(max(subImage{i}));
      end

      comp = [subImage{1}, zeros(16,1), subImage{2} ; ...
              zeros(1,33) ; ...
              subImage{3}, zeros(16,1), subImage{4} ];

      comp = [comp, zeros(33,1), [zeros(1,32); subImage{5}]; ...
              zeros(1,66); ...
              [zeros(32,1), subImage{6}], zeros(32,1), subImage{7} ];

      comp = [zeros(70,2) [zeros(2,66); comp; zeros(2,66)] zeros(70,2)];

      greyscaleImage = reshape([comp comp comp], ...
                               size(comp,1), size(comp,2), 3);

      subplot(2,3,6);
      image(greyscaleImage), ...
          axis square, axis equal, axis off, ...
          title(sprintf('Final Composite Image\n(each sub-image renormalized)'));
    end

  end
end
