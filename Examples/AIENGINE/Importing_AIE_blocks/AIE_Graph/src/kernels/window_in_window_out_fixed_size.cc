///////////////////////////////////////////////////////////////////////////
// Copyright 2020 Xilinx
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
#include "aie_api/aie.hpp"
#include "window_in_window_out_fixed_size.h"
void add_kernel(adf::input_buffer<int16> & restrict inw1,adf::input_buffer<int16> & restrict inw2, adf::output_buffer<int16> &  restrict outw)
{

 
    auto outwt = aie::begin_vector<NUM_SAMPLES>( outw );
    auto inw1t = aie::begin_vector<NUM_SAMPLES>( inw1 );
    auto inw2t = aie::begin_vector<NUM_SAMPLES>( inw2 );
    
    aie::vector<int16, 16> temp1 = *inw1t++;
    aie::vector<int16, 16> temp2 = *inw2t++;
    aie::vector<int16, 16> temp_out= aie::add(temp1,temp2) ;
 
           (*outwt++) = temp_out;

}