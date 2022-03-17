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

// This example shows how model composer supports overloading of function
// with same number of input/output arguments. The following defines two 
// forms of a function.

#include <stdint.h>
#include <ap_fixed.h>

int16_t func7_c(int16_t var) {
    if(var < 0)
        var = -var;
     return var;
}

ap_fixed<16,10> func7_c(ap_fixed<16,10> var) {
    if(var < 0.0)
        var = -var;
    return var;
}