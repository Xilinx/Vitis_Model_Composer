# HDL Examples<a name="HDL_Examles"></a>

### AXI_IP Examples

<table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./AXI_IP/Complex_Multiplier/README.md">How to use AXI Complex Multiplier</a>
 </td>
 <td>This example shows how to use Complex Multiplier
  </td>
 </tr>
  <tr>
 <td align="left">
   <a href="./AXI_IP/DDS_Compiler/README.md">How to use AXI DDS Compiler</a>
 </td>
 <td>This example shows how to use DDS Compiler
  </td>
 </tr>
  <tr>
 <td align="left">
   <a href="./AXI_IP/Fast_Fourier_Transform/README.md">How to use AXI Fast Fourier Transform</a>
 </td>
 <td>This example shows how to use Fast Fourier Transform by performing FFT and IFFT.
  </td>
 </tr>
 </table>
 
### Digital Communications Examples

<table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./Digital_Communications/16_QAM_demodulator/README.md">16-QAM demodulator</a>
 </td>
 <td>This design implements an equalized 16-QAM demodulator for use in a software defined radio.
 </td>
 </tr>
  <tr>
 <td align="left">
   <a href="./Digital_Communications/Costas_loop_carrier_recovery/README.md">Costas loop carrier recovery</a>
 </td>
 <td>This design implements the Costas loop using the DDS block.</td>
 </tr>
 </table>

### Digital Filtering Examples

<table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./Digital_Filtering/SSR_FIR/README.md">High speed SSR FIR</a> <img src="../../Images/new.PNG" width="50">
 </td>
 <td> This reference design can be used as a starting design point when efficient implementations of very high data rate (over 1 Gsps) Single Rate FIRs are required.</td>
 <tr>
 <td align="left">
   <a href="./Digital_Filtering/2nd_Order_Direct_Form_I_Impl/README.md">2nd-order Direct Form I implementation</a>
 </td>
 <td>This design example shows two distinct FPGA implementations of a 2nd order IIR filter in Direct Form I, and compares them to the double precision Simulink IIR filter block. </td>
 </tr>
  <tr>
 <td align="left">
   <a href="./Digital_Filtering/LMS_based_adaptive_Equalization/README.md">LMS based adaptive equalization</a>
 </td>
 <td>This design shows a T/2 adaptive Fractionally Space Equalizer (FSE) operating on a 16-QAM data source with noise and filtering introduced in the channel model. </td>
 </tr>
  <tr>
 <td align="left">
   <a href="./Digital_Filtering/LMS_based_adaptive_Equalization_Synth_RTL/README.md">LMS-based adaptive equalization (Synthesizable RTL)</a>
 </td>
 <td>This design shows how to use the MCode block to create fully synthesizable register transfer level (RTL) designs in Model Composer.
 </td>
 </tr>
   <tr>
 <td align="left">
   <a href="./Digital_Filtering/Multi_Channel_Folded_impl/README.md">Multi-channel, folded implementation</a>
 </td>
 <td>This design demonstrates how multiple IIR filters can be implemented using a single time-shared second-order section (biquad). Specifically, 15 distinct IIR filters, each consisting of four cascaded biquads, are realized in a "folded" architecture that uses a single hardware biquad.</td>
 </tr>
 <tr>
 <td align="left">
   <a href="./Digital_Filtering/Reloadable_FIR_Filter/README.md">Reloadable FIR Filter</a>
 </td>
 <td>This example shows how to reload the 5-tap symmetric FIR with the coefficient values of 7 8 9 8 7.
 </td>
 </tr>
 </table>
 
### Floating Point Examples

<table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./Floating_Point/2nd_order_Direct_Form_II/README.md">2nd-order Direct Form II implementation</a>
 </td>
 <td>This design shows two distinct FPGA implementations of a 2nd order IIR filter in Direct Form II, and compares them to the double precision Simulink IIR filter block.
 </td>
 </tr>
<tr>
 <td align="left">
   <a href="./Floating_Point/3x3_Matrix_Determinant/README.md">3x3 Matrix Determinant</a>
 </td>
 <td>This design demonstrates the calculation of the determinant of a 3x3 matrix with real, single precision floating point elements. It showcases the Black Box block for bringing hand-coded VHDL or Verilog code into Model Composer. It also shows the DSPFP32 for performing floating-point operations on Versal devices.
 </td>
 </tr>
 </table>

 
### General Examples

<table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./General/Color_Space_Converter/README.md">Color space converter</a>
 </td>
 <td>This design implements R-G-B to Y-Pr-Pb color space conversion.
 </td>
 </tr>
  <tr>
 <td align="left">
   <a href="./General/Image_Processing/README.md">2D DWT filter</a>
 </td>
 <td>This design performs a 2D DWT filtering on 64x64 pixel image. </td>
 </tr>
  <tr>
 <td align="left">
   <a href="./General/MRI_Image_Reconstruction_2DFFT/README.md">Two Dimensional FFT using Corner Turning Technique for MRI Sagittal Image Reconstruction</a>
 </td>
 <td>This design performs a two dimensional FFT (2D-FFT) on MRI input data.
  </td>
 </tr>
 </table>
 
### MATH Examples

<table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./Math/Logic_and_cores_impl_of_Fibonacci_Num_Gen/README.md">Logic and Cores Fibonacci Number Generator</a>
 </td>
 <td>This design is a logic and cores implementation of a Fibonacci number generator. That is, given a non-negative integer n, it computes the recursively defined sequence x_0 = 1, x_1 = 1, ... , x_n = x_{n-2} + x_{n-1}.
  </td>
 </tr>
   <tr>
 <td align="left">
   <a href="./Math/Synthesizable_Mcode_impl_of_Fibonacci_Num_Gen/README.md">MCode-Based Fibonacci Number Generator</a>
 </td>
 <td>This design implements a Fibonacci number generator in an MCode block. That is, given a non-negative integer n, it computes the recursively defined sequence x_0 = 1, x_1 = 1, ... , n_n = x_{n-2} + x_{n-1}.
  </td>
 </tr>
 </table>
 
### RFSoC Examples

<table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./RFSoC/SSR_Digital_Down_Conversion/README.md">Programmatic Digital Down converter using SSR</a>
 </td>
 <td>This design implements a digital down converter that reduces the sampling rate of the input signal to match the desired output sampling rate. In this example we go from 1.5GSPS to 187.5MSPS.
 </td>
 </tr>
  <tr>
 <td align="left">
   <a href="./RFSoC/SSR_Inverse_Fourier_Tansform/README.md">IFFT computation using the Vector FFT block</a>
 </td>
 <td>This model computes the Inverse FFT using an FFT block.
 </td>
 </tr>
  <tr>
 <td align="left">
   <a href="./RFSoC/Symmetric_Interpolation_FIR/README.md">Highly Optimized Symmetric Interpolation FIR implementation</a>
 </td>
 <td>This design shows a 273-tap polyphase FIR filter, which consumes 4 samples per clock cycle, interpolate by 2 (1 GSPS input rate to 2GSPS output rate), and Symmetric coefficients using FIR compiler blocks.
 </td>
 </tr>   
 </table>

--------------
Copyright 2021 Xilinx

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

