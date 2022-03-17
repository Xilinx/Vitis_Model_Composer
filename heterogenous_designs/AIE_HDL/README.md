# Examples with AI Engine and HDL blocks

In Model Composer, you can simulate a design containing both AI Engine blocks and HDL blocks (targetted to the FPGA fabric). To connect these two domains, we use the "AIE to HDL" and "HDL to AIE" blocks.

![](images/screen_shot.PNG)

## Knoweldge nuggets
 :bulb: While simualtion of AI Engine block is bit accurate and untimed, HDL block simulation is both bit accurate and timed, hence the need for the *interfaces* blocks. 
 
 :bulb: The HDL desgin must have an AXI4 stream connections (tdata, tvalid, and tready signals) to be able to connect to the interface blocks. The connection between the AI Engine and FPGA fabric in hardware is also a stream connection.

## Examples
- [Design with HDL and AI Engine blocks](AIE_HDL_cosim/README.md)
- [Design with imported RTL and AI Engine blocks](AIE_HDL_cosim_rtl_blackbox/README.md)
- [2D FFT desgin with both AI Engine and HDL blocks](../FFT2D/HDL_AIE/README.md)

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
