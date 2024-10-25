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


#ifndef __ADD_KERNEL_H__
#define __ADD_KERNEL_H__

#include <adf.h>
#include "aie_api/aie.hpp"
#define NUM_SAMPLES 16
void add_kernel(adf::input_buffer<int16> & restrict inw1,adf::input_buffer<int16> & restrict inw2, adf::output_buffer<int16> &  restrict outw);


#endif //__ADD_KERNEL_H__