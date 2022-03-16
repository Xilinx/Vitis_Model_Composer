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

#ifndef __XMC_WIN_IN_WIN_OUT_H__
#define __XMC_WIN_IN_WIN_OUT_H__

#include <adf.h>
#include "src/kernels/window_in_window_out_fixed_size.h"

class Win_in_win_out : public adf::graph {
private:
   adf::kernel add_kernel_0;

public:
   adf::input_port In1, In2;
   adf::output_port Out1;

   Win_in_win_out() {
      // create kernel add_kernel_0
      add_kernel_0 = adf::kernel::create(add_kernel);
      adf::source(add_kernel_0) = "src/kernels/window_in_window_out_fixed_size.cc";
      adf::runtime<ratio>(add_kernel_0) = 0.9;

      // create nets to specify connections
      adf::connect< adf::window<32> > net0 (In1, sync(add_kernel_0.in[0]));
      adf::connect< adf::window<32> > net1 (In2, sync(add_kernel_0.in[1]));
      adf::connect< adf::window<32> > net2 (sync(add_kernel_0.out[0]), Out1);
   }
};

#endif // __XMC_WIN_IN_WIN_OUT_H__