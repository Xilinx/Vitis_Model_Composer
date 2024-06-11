COL=256;
ROW=384;
NUM=6;
K_COL=COL;
K_ROW=ROW/NUM;
PLIO_NUM=3;

buffer_tiling

inMat = randn(ROW,COL,'single')*2^14;
inMatNormalized= (inMat-mean(inMat,'all'))/std(inMat,1,'all');