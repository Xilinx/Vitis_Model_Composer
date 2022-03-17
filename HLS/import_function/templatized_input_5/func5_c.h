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

// This example shows how to perform simple arithmetic operations
// on template parameters. In this example, the output size will be
// half the size of the input. 

#include <stdint.h>

#pragma XMC INPORT in
template<int NUMOFELEMENTS>
void func5_c(int16_t in[NUMOFELEMENTS], int16_t out0[NUMOFELEMENTS/2], 
           int16_t out1[2 * NUMOFELEMENTS - 15]) {
    
    for (int i = 0; i < NUMOFELEMENTS/2; i++) {
        out0[i] = in[i];
    }
    for (int i = 0; i < 2 * NUMOFELEMENTS - 15; i++) {
        out1[i] = NUMOFELEMENTS + i;  
    }
}
