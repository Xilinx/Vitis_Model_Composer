// /**********
// © Copyright 2020 Xilinx, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// **********/

#ifndef _KERNELS_H_
#define _KERNELS_H_ 1

#include "kernels_common.h"

class OverlapSave {
    private:
    alignas(32) cint16 overlap_state [TAP_NUM];

    public:
    void overlap_save(adf::input_buffer<cint16,adf::extents<WIN_SIZE> > & restrict win_i,
                      adf::output_buffer<cint16,adf::extents<FFT_SIZE> > & restrict win_o);

    static void registerKernelClass()
    {
        REGISTER_FUNCTION(OverlapSave::overlap_save);
    };
};

class ApplyFdTaps {
    private:
    alignas(32) cint16 (&coeff)[FFT_SIZE];

    public:
    ApplyFdTaps(cint16 (&taps)[FFT_SIZE]):coeff(taps) {};


    void apply_fd_taps(adf::input_buffer<cint16,adf::extents<FFT_SIZE> > & restrict win_i,
                       adf::output_buffer<cint16,adf::extents<FFT_SIZE> > & restrict win_o );

    static void registerKernelClass()
    {
        REGISTER_FUNCTION(ApplyFdTaps::apply_fd_taps);
        REGISTER_PARAMETER(coeff);
    };
};


void overlap_discard(adf::input_buffer<cint16,adf::extents<FFT_SIZE> > & restrict win_i,
                       adf::output_buffer<cint16,adf::extents<WIN_SIZE> > & restrict win_o );

#endif
