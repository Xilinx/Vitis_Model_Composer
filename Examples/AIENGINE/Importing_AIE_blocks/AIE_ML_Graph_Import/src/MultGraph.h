/*
Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
SPDX-License-Identifier: MIT
*/

#pragma once

#include <adf.h>
#include "kernels.h"
#include "system_settings.h"
#include "tiling_parameters.h"

using namespace adf;


template<typename ITYPE,typename OTYPE, int SHIFT_RESULT,int ARRAY_COL>
class MatrixMultiply : public graph {
public:
    input_port inA,inB;
    output_port outC;

    kernel MatMult;
    shared_buffer<ITYPE> mtxA,mtxB;
    shared_buffer<OTYPE> mtxC;


    MatrixMultiply() {

        // kernels
        MatMult = kernel::create(ClassicMatMult<ITYPE,OTYPE,SHIFT_RESULT>);
        source(MatMult) = "src/matmult.cpp";
        runtime<ratio>(MatMult) = 0.9;
        location<kernel>(MatMult) = tile(ARRAY_COL,0);

        // Shared Buffers
        mtxA = shared_buffer<ITYPE>::create({A_COLS,A_ROWS},1,1);
        mtxB = shared_buffer<ITYPE>::create({B_COLS,B_ROWS},1,1);

        mtxC = shared_buffer<OTYPE>::create({C_COLS,C_ROWS},1,1);


        num_buffers(mtxA) = 2;
        num_buffers(mtxB) = 2;
        num_buffers(mtxC) = 2;


        // Connect Input A to Mem Tile and Non Sparse Kernel
        connect (inA, mtxA.in[0]);
        write_access(mtxA.in[0]) = WriteAns_pattern;

        connect(mtxA.out[0], MatMult.in[0]);
        dimensions(MatMult.in[0]) = DimAin;
        read_access(mtxA.out[0]) = ReadAns_pattern;

        // Connect Input B to Mem Tile and Non Sparse Kernel
        connect(inB, mtxB.in[0]);
        write_access(mtxB.in[0]) = WriteBns_pattern;

        connect(mtxB.out[0], MatMult.in[1]);
        dimensions(MatMult.in[1]) = DimBin;
        read_access(mtxB.out[0]) = ReadBns_pattern;

        // Connect Non Sparse Kernel to MEM Tile and then to Output
        connect(MatMult.out[0],mtxC.in[0]);
        write_access(mtxC.in[0]) = WriteCns_pattern;
        dimensions(MatMult.out[0]) = DimCout;
        connect(mtxC.out[0],outC);
        read_access(mtxC.out[0]) = ReadCns_pattern;

    };
};
