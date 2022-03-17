///////////////////////////////////////////////////////////////////////////
// Copyright 2021 Xilinx
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

// In this example, we see how to specify port directions explicitly using 
// XMC pragma.Note the usage of .h for function declaration and .cpp file 
// for function definition.
// Without the pragmas, both arguments will be set as output ports of the block.

#include <stdint.h>

#pragma XMC INPORT in
#pragma XMC OUTPORT out

void func4_a(int16_t in[5], int16_t out[5]);


