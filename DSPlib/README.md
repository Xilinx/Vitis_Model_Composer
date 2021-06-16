# Using AI Engine functions from DSPlib

DSPlib is a library of commonly used DSP functions optimized for AI Engines. To facilitate the use of these functions in a design, Vitis Model Composer provides different DSPlib functions as blocks within the Xilinx Toolbox/AI Engine library. You can conveniently drag and drop a block into your model from the Simulink Library browser and configure the block.

Here we demonstrate how you can use these functions in Vitis Model Composer.

![](image/screen_shot.png)

Here you see examples for FIR,FFT and Matrix Multiply functions.

## Knowledge nuggets

:bulb: For FIR and FFT examples, we are using the blocks available in AIEngine/DSPlib library directly. However, for matrix multiply example, we are importing the function as a graph from the  DSPlib [Git hub location].

:bulb: When importing the graph, you can either use the graph header file from 'dsplib/L2/include' or you can write a .cpp file to instantiate the graph and use that file to import as a block.

## Examples
- [Using the AI Engine FIR block from the library browser](fir)
- [Usign the AI Engine FFT block from the library browser](fft)
- [Importing Matrix Multiply from DSPLib as a block](matrix_multiply)

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
