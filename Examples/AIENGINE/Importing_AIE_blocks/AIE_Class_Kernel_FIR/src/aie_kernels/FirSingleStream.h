/*
* (c) Copyright 2020 Xilinx, Inc. All rights reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
*/
#pragma once

#include <adf.h>
#include <aie_api/aie.hpp>

namespace SingleStream {

    template<int NSamples,int ShiftAcc>
    class FIR_SingleStream {
    private:
    alignas(32) cint16 eq_coef[32];
    aie::vector<cint16,32> delay_line;

    public:
    FIR_SingleStream(const cint16 (&taps)[32])
    {
    filter_init(taps);
    };

    void filter(input_stream_cint16*  sin,output_stream_cint16*  sout);
    void filter_init(const cint16 (&taps)[32]);

    static void registerKernelClass()
    {
    REGISTER_FUNCTION(FIR_SingleStream::filter);
    };
    };

}
