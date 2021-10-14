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

// This example shows how to use complex signals and parameterize
// the datatype


#include <complex>
#pragma XMC OUTPORT Out

template <typename TYPE>
void func4_d(std::complex< TYPE > In1, std::complex< TYPE > In2,
             std::complex< TYPE > *Out)
{
   *Out = In1 * In2;
}





