COL=128;
ROW=384;
K_COL=128;
K_ROW=64;
NUM=6;
PLIO_NUM=3;

buffer_tiling

inMat = randn(ROW,COL,'single')*2^14;
inMatNormalized= (inMat-mean(inMat,'all'))/std(inMat,1,'all');

inMat1=reshape(inMat(1:ROW/PLIO_NUM,:)',[],1);
inMat2=reshape(inMat(ROW/PLIO_NUM+1:ROW/PLIO_NUM*2,:)',[],1);
inMat3=reshape(inMat(ROW/PLIO_NUM*2+1:ROW,:)',[],1);

out = sim("normalization.slx");

outMat1=reshape(simout1,128,[])';
outMat2=reshape(simout2,128,[])';
outMat3=reshape(simout3,128,[])';

outMatNormalized = [outMat1;outMat2;outMat3];

figure
imagesc(inMatNormalized)
figure
imagesc(outMatNormalized)

max(max(abs(inMatNormalized-outMatNormalized)))
