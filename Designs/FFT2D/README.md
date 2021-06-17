# 2D FFT using both AI Engines and Programmable Logic
In this section we showcase two 2D-FFT designs using both AI Engines and Programmable Logic. 
Two 1D FFTs are implemented on AI Engiens and a transpose operation is implemented on the programmable logic.
In one example, the transpose operation is implemented using the HLS Kernel and in another example the transpose operation is implemted using HDL blocks.

## Examples

- [2D FFT design using AI Engines and HLS Kernel block](rtp_scalar)
- [2D FFT design using AI Engines and HDL blocks](rtp_vector)

## Knowledge nuggets
:bulb: You can seamlessly connect AI Engine blocks to HLS kernel blocks or HDL blocks and run co-simulation in Vitis Model Composer.



<p align="center">
<img src="images/fft_2d_in_out.png">
</p>

------------
Copyright 2020 Xilinx

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
