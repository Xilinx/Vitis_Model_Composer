/*
 * (c) Copyright 2021-2022 Xilinx, Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
 
 #include <adf.h>

template <int FRAME_LENGTH>
void FreqShift(adf::input_buffer<cint16>& __restrict in, 
               adf::output_buffer<cint16>& __restrict out);

template <int FRAME_LENGTH>
void FreqShift8(adf::input_buffer<cint16>& __restrict in1, 
                adf::input_buffer<cint16>& __restrict in2, 
                adf::input_buffer<cint16>& __restrict in3, 
                adf::input_buffer<cint16>& __restrict in4, 
                adf::input_buffer<cint16>& __restrict in5, 
                adf::input_buffer<cint16>& __restrict in6, 
                adf::input_buffer<cint16>& __restrict in7, 
                adf::input_buffer<cint16>& __restrict in8,
                adf::output_buffer<cint16>& __restrict out);