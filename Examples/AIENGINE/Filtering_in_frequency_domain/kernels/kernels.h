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
#define _KERNELS_H_

#include "kernels_common.h"


template <int NUM_OF_FRAMES>
void overlap_save(adf::input_buffer<cint16,adf::extents<adf::inherited_extent>, adf::margin<TAP_NUM>> & restrict win_i,
                                              adf::output_buffer<cint16> & restrict win_o );


template <int NUM_OF_FRAMES>
class ApplyFdTaps {
    private:
    alignas(32) cint16 coeff[FFT_SIZE];

    public:
    ApplyFdTaps(const cint16 (&taps)[FFT_SIZE]) {
        for(int i = 0; i<FFT_SIZE; i++)
        {
            coeff[i] = taps[i];
        }
    };

    void apply_fd_taps(adf::input_buffer<cint16> & restrict win_i,
                       adf::output_buffer<cint16> & restrict win_o );

    static void registerKernelClass()
    {
        REGISTER_FUNCTION(ApplyFdTaps::apply_fd_taps);
    };
};


template <int NUM_OF_FRAMES>
void overlap_discard(adf::input_buffer<cint16> & restrict win_i,
                                                      adf::output_buffer<cint16> & restrict win_o );
#endif
