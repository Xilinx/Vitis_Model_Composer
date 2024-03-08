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
#include "window_in_window_out_fixed_size.h"
void add_kernel(input_window_int16 * inw1,input_window_int16 * inw2, output_window_int16 * outw)
{
	int16 temp1,temp2,temp_out;
	for (unsigned i=0; i<NUM_SAMPLES; i++) {
		window_readincr(inw1,temp1);
		window_readincr(inw2,temp2);
		temp_out = temp1 + temp2;
		window_writeincr(outw,temp_out);
	}
}