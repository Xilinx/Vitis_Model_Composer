# Using AI Engine functions from DSPlib

DSPlib is a library of commonly used DSP functions optimized for AI Engines. In 2020.2 release, you can find 
this library at the *Versal AI Engines Secure Site* at https://www.xilinx.com/member/versal_ai_engines.html as a zip file.

Here we demonstrate how you can use these functions in Model Composer.

In 2020.2, the AI Engine FIR function is part of the Simulink library browser. You can conveniently drag and drop it into your model and configure it for your application. The other two functions, FFT and Matrix Multiply, can be imported as a block. Here you see examples for all these functions.

## Knowledge nuggets

:bulb: Except for the FIR example, we are importing the functions as a graph from the L2 directory of DSPlib.

:bulb: When importing the graph, the only file we need to write, in addition to the files provided in the DSPlib, is a .cpp file to instantiate the graph.

## Examples
- [Using the AI Engine FIR block from the library browser](fir)
- [Importing FFT from DSPLib as a block](fft)
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
