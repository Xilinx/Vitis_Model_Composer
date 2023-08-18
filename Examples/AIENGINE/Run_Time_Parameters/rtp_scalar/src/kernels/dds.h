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

#ifndef __DDS_H
#define __DDS_H
#include "stdlib.h"
#include <stdio.h>
#include <adf.h>

class dds
{
private: 
    int16 chess_storage(%chess_alignof(v8cint16)) dds_stored[16];
    int32 phase_in;

public:
    dds(const int16 (&dds_stored)[16]);
    void sine(const int32 phase_increment,output_window_cint16 * owin);
    
    static void registerKernelClass()
    {
     REGISTER_FUNCTION(dds::sine);   
    }   
};
#endif __DDS_H