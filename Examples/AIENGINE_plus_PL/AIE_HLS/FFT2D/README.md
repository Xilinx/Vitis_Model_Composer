# 2D FFT using both AI Engines and Programmable Logic (HLS)
In this section we showcase a 2D-FFT design using both AI Engines and Programmable Logic.
Two 1D FFTs are implemented on AI Engines and a transpose operation is implemented on the programmable logic using the HLS Kernel block.

## Knowledge nuggets
:bulb: You can seamlessly connect AI Engine blocks to HLS kernel blocks.

:bulb: _AIE to HLS_ blocks may be needed for connectivity if there is a need to change the data type.

:bulb: Note the interface specificaiton in the HLS code. These instruct the Vitis HLS compiler to infer an AXI stream interface for the IP. This interface will be used for the Hardware Validaiton flow in Vitis Model Composer:
  
>*#pragma HLS INTERFACE ap_ctrl_none port=return*  
>*#pragma HLS interface axis port=in*  
>*#pragma HLS interface axis port=out*


<p align="center">
<img src="images/fft_2d_AIE_HLS_screen_shot.png">
</p>

------------
Copyright 2020-2022 Xilinx
Copyright 2023 Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
