# 2nd-order Direct Form I implementation

This design example shows two distinct FPGA implementations of a 2nd order IIR filter in Direct Form I, and compares them to the double precision Simulink IIR filter block.

IIR_Cmult is implemented using constant coefficient multipliers implemented in LUTs,

IIR_mult is implemented using embedded multipliers.

Multiple display blocks allow the user to visualize the Spectrum and Transfer functions of each implementation as well as the quantization error in the DISPLAY block.

All the variables such as data width, coefficient width, Sample period, and coefficient values are initialized in the sysgenIIR_PreLoadFcn.m file. The default setting use 12 bit data and coefficients

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
