///////////////////////////////////////////////////////////////////////////
// Copyright 2020-2022 Xilinx
// Copyright 2023 Advanced Micro Devices Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
///////////////////////////////////////////////////////////////////////////

#include <adf.h>
#include <aie_api/aie.hpp>
#include <aie_api/aie_adf.hpp>

template <int FRAME_LENGTH>
void passthrough(adf::input_buffer<cint32>& in, 
                 adf::output_buffer<cint32>& out) { 

    // Pointers to 8-element vectors from input and output
    auto pi1 = aie::begin_vector_circular<8>(in);
    auto po1 = aie::begin_vector_circular<8>(out);  

    aie::vector<cint32,8> data;

    for (unsigned i = 0; i < FRAME_LENGTH/8; i++) {
        // Get 8 samples from input
        data = *pi1++;
        
        // Send 8 samples to output 
        *po1++ = data;
    }

}