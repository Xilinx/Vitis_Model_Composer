mtxA_w = [];
for i=0:2
    pattern = struct('buffer_dimension', [COL,ROW], 'tiling_dimension', [COL,ROW/PLIO_NUM], 'offset', [0,ROW/PLIO_NUM*i]);
    mtxA_w = [mtxA_w, pattern];
end

mtxA_r = [];
for i=0:5
    pattern = struct('buffer_dimension', [COL,ROW], 'tiling_dimension', [K_COL,K_ROW], 'offset', [0,K_ROW*i])
    mtxA_r = [mtxA_r, pattern];
end

mtxB_w = [];
for i=0:5
    pattern = struct('buffer_dimension', [COL,ROW], 'tiling_dimension', [K_COL,K_ROW], 'offset', [0,K_ROW*i]);
    mtxB_w = [mtxB_w, pattern];
end
			
mtxB_r = [];
for i=0:2
    pattern = struct('buffer_dimension', [COL,ROW], 'tiling_dimension', [COL,ROW/PLIO_NUM], 'offset', [0,ROW/PLIO_NUM*i])
    mtxB_r = [mtxB_r, pattern];
end