# Vitis Model Composer

![](images/model_composer_title3.png)

## How to access the content of this repository?
    
Starting from the 2020.2 version, we are storing and managing a subset of the product examples in GitHub. This way, users will have access to the most up-to-date examples. You can get the examples from this repository or directly from the tool.

Click [here](example_access.md) to learn how to access the examples in GitHub.

## AI Engine Examples

<table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./Importing_AIE_blocks/README.md">Importing Kernels and Graphs into Model Composer</a>
 </td>
 <td>Examples on importing Kernels and Graphs into Model Composer as blocks. This include importing templatized class based kernels, templatized AI Engine functions, and graphs. </td>
 </tr>
 <tr>
 <td align="left">
   <a href="./Run_Time_Parameters/README.md">Run time parameters (RTP)</a>
 </td>
 <td>Examples of kernels with RTP input. RTP inputs can be sync or async. </td>
 </tr>
 <tr>
 <td align="left">
   <a href="./DSPlib/README.md">DSP Functions</a>
 </td>
 <td>AI Engine FIR filters and FFT. Importing Matrix Multiply as a graph into Vitis Model Composer.</td>
 </tr>
 <tr>
 <td align="left">
   <a href="./AIE_HDL/README.md">Designs with both AI Engine and RTL blocks</a>
 </td>
 <td>Examples of designs with both AI Engine kernels and RTL functions. Here you can see examples of importing RTL code into Model Composer and co-simulation with AI Engine   blocks at high speeds.
 </td>
 </tr>
 <tr>
 <td align="left">
   <a href="./AIE_HLS/README.md">Design with both AI Engines and HLS kernels</a>
 </td>
 <td>Example of a design with both AI Engine kernels and an HLS kernel.
 </td>
 </tr>
 </table>
 
 ## Design Examples
 
 <table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./Designs/SingleStreamSSR_FIR">Super Sample Rate FIR filter</a>
 </td>
 <td> This design showcases a Super Sample Rate FIR filter to process a 4GSPS input stream. In this design we also compare the output of our AI Engine subsystem with the output of a Simulink FIR block (our golden refernece) both in time and in frequency. 
 </td> 
 </tr>
    
 <tr>
 <td align="left">
 <a href="./Designs/FFT2D">2D FFT (AI Engines + HDL/HLS) </a>
 </td>
 <td> The designs here showcase 2D-FFTs that are implemented both in AI Engines and Programmable Logic(PL). In one example the PL is implemented using HLS and in another example the PL is implemented using HDL blocks in Vitis Model Composer.</td>
 </tr>
    
 </table>

  ## Mini Tutorials
 
 <table style="width:100%">
 <tr>
 <td width="35%" align="center"><b>Topic</b>
 <td width="65%" align="center"><b>Description</b>
 </tr>
 <tr>
 <td align="left">
   <a href="./Variable_Size_Signals/README.md">What are Variable-Size Signals?</a>
 </td>
 <td>All you need to know about Variable-Size Signals in Simulink.
 </td>
 </tr>
 
 <tr>
 <td align="left">
   <a href="./Setting_Signal_Size/README.md">How to properly set the Signal Size property on AI Engine kernel blocks with stream or cascade outputs?</a>
 </td>
 <td>Setting the signal size property for AI Engine kernels with stream and cascade outputs.
 </td>
 </tr>
 <tr>
 <td align="left">
   <a href="./AIE_HDL/Connecting_AIE_to_HDL/README.md">How to properly set the parameters for the AIE to HDL and HDL to AIE blocks?</a>
 </td>
 <td> Setting the properties of the AIE to HDL and HDL to AIE blocks could be tricky. This tutorial explains how to set these parameters. 
 </td>
 </tr>
 </table>

## What's new in 2021.1?
Vitis Model Composer now contains the functionality of Xilinx System Generator for DSP.  Users who have been using Xilinx System Generator for DSP can continue development using Vitis Model Composer.

### AI Engines 
* A comprehensive constraint editor enables users to specify any constraint for AI Engine kernels in Vitis Model Composer. The generated ADF graph will contain these constraints.
* Addition of AI Engine FFT and IFFT blocks to the library browser. 
* Users now have access to many variations of AI Engine FIR blocks in the library browser. 
* Ability to specify filter coefficients using input ports for FIR filters. 
* Addition of two new utility blocks "RTP Source" and "To Variable Size".
* Enhanced AIE Kernel import block now also supports importing templatized AI Engine functions. 
* Ability to specify Xilinx platforms for AI Engine designs in the Hub block.
* Through the Hub block, users can relaunch Vitis Analyzer at any time after running AIE Simulation. 
* Users can now plot cycle approximate outputs and see estimated throughput for each output using Simulink Data Inspector. 
* Enhanced usability to import a graph as a block using only the graph header file. 
* Revamping of the progress bar with cancel button.
* Usability improvement during importing an AI Engine kernel or simulation of a design when MATLAB working directory and model directory are not the same. 
* Profiling during AIE Simulation is now disabled by default. It can be optionally enabled from the Model Composer Hub block.
* New TX Chain 200MHz example. 
* New 2d FFT examples showcasing designs with HLS, HDL, and AI Engine blocks.
### HDL
* Simulation speed enhancement for SSR FIR (more than 10x improvement), and SSR FFT.
* Simulation speed enhancement for memory blocks like RAMs, and FIFOs
* Questa Simulator updated with VHDL 2008 in the Black-box import flow
### General
* Vitis Model Composer now contains the functionality of Xilinx System Generator for DSP.  Users who have been using Xilinx System Generator for DSP can continue development using Vitis Model Composer.
* MATLAB Support - R2020a, R2020b, and R2021a
  
<p align="center">
<img src="images/model_composer_image.PNG">
</p>

--------------
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
