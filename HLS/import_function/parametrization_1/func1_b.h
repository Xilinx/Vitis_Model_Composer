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


// In this example two editable fields will get added to the block dialog box.
// You can assign a default argument but they should appear at the end of
// the function argument list.

#include <stdint.h>

#pragma XMC PARAMETER P1, P2
void func1_b(int16_t in, int8_t &out, double P1, int8_t P2 = 10)
{
   out = in*P1 + P2;
}


