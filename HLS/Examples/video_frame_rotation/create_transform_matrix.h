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

// Using the XMC_SUPPORTS_STREAMING below, we speficy that create_transform_matrix 
// function supports streaming. Therefore, the elements of non-scalar arguments 
// of create_transform_matrix must be accessed in strict sequential order. 
// So in this case, first assign transform_matrix[0][0], 
// then transform_matrix[0][1], ... and finally assign transform_matrix[2][2].

#include <stdint.h>
#include "hls_math.h"

#pragma XMC SUPPORTS_STREAMING
void create_transform_matrix(const float angle, const float center_x, 
        const float center_y, float transform_matrix[9])
{ 
    const float scale = 1;
    
    float a = scale * hls::cosf(angle);
    float b = scale * hls::sinf(angle);
    
    
    transform_matrix[0] = a;
    transform_matrix[1] = b;
    transform_matrix[2] = (1-a)*center_x-b*center_y;
    
    transform_matrix[3] = -b;
    transform_matrix[4] = a;
    transform_matrix[5] = b*center_x +(1-a)*center_y;
    
    transform_matrix[6] = 0;
    transform_matrix[7] = 0;
    transform_matrix[8] = 0;
    
    
}


