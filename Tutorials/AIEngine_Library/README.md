<table class="sphinxhide" width="100%">
 <tr width="100%">
    <td align="center"><img src="https://raw.githubusercontent.com/Xilinx/Image-Collateral/main/xilinx-logo.png" width="30%"/><h1>AI Engine Development</h1>
    <a href="https://www.xilinx.com/products/design-tools/vitis.html">See Vitis™ Development Environment on xilinx.com</br></a>
    <a href="https://www.xilinx.com/products/design-tools/vitis/vitis-ai.html">See Vitis™ AI Development Environment on xilinx.com</a>
    </td>
 </tr>
</table>

# Vitis Model Composer for AI Engine Tutorial Series

Vitis Model Composer enables the rapid simulation, exploration, and code generation of algorithms targeted for AI Engines from within the Simulink® environment. You can achieve this by importing AI Engine kernels and data-flow graphs into Vitis Model Composer as blocks and controlling the behavior of the kernels and graphs by configuring the block GUI parameters. Simulation results can be visualized by seamlessly connecting Simulink source and sink blocks with Vitis Model Composer AI Engine blocks.

Vitis Model Composer provides a set of AI Engine library blocks for use within the Simulink environment. These include:
 * Blocks to import kernels and graphs which can be targeted to the AI Engine portion of Versal® devices.
 * Block to import HLS kernels which can be targeted to the PL portion of Versal devices.
 * Blocks that support connection between the AI Engine and the Xilinx HDL blockset.
 * Configurable AI Engine functions such as FIR, FFT, IFFT etc.

Vitis Model Composer can be used to create complex systems targeting the PL (RTL and HLS blocksets) and the AI Engine array (AIE blockset) at the same time. The complete system can be simulated in Simulink, and the code generated (RTL for the PL and C++ graph for the AI Engine array).

:warning: The AI Engine Lab can be done only in a Linux environment.

## Overview

This tutorial includes the following labs which introduce AI Engine support in Vitis Model Composer.

### [Lab 1](./01-Introduction_to_Versal_ACAP_and_AI_Engines/README.md)

Introduction to Versal ACAP and AI Engines
 * Learn about the Versal ACAP architecture and AI Engines
 * Install required software to compile and simulate AI Engine designs
 * Simulate an example AI Engine design in Vitis Model Composer

### [Lab 2](./02-Build_and_Simulate_AI_Engine_Design/README.md)

Build and Simulate an AI Engine Design
 * Construct a signal processing chain using AI Engine DSP library blocks
 * Generate a top-level graph
 * Simulate the design using the AI Engine SystemC Simulator

### [Lab 3](./03-Import_Custom_AI_Engine_Code/README.md)

Import Custom AI Engine Code
 * Learn about AI Engine programming and study an AI Engine kernel function 
 * Import the AI Engine kernel function into Vitis Model Composer
 * Simulate the AI Engine kernel function and understand its execution within Vitis Model Composer

### [Lab 4](./04-AI_Engine_Code_Generation/README.md)

AI Engine Code Generation and Cycle-Approximate Simulation
 * Generate AI Engine graph code from a Vitis Model Composer design
 * Simulate AI Engine design and review estimated throughput
 * Automate building and simulation of AI Engine as part of a larger design

### [Lab 5](./05-Vitis_Analyzer/README.md)

View AI Engine Designs in Vitis Analyzer
 * Widen PLIO width to increase design throughput
 * Cascade FIR filter algorithm across multiple AIE kernels
 * View detailed timing information in the Vitis Analyzer and calculate latency

### [Lab 6](./06-Hardware_Validation/README.md)

Hardware Validation of Versal ACAP Design
 * Generate a hardware image to perform validation
 * Run hardware emulation to simulate the behavior of the Versal ACAP design including AI Engine, PL and PS
 * Download the hardware image to a VCK190 board and perform hardware validation

---

&copy; Copyright 2023 Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

```
    http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

<p align="center"><sup>XD058 | &copy; Copyright 2023 Advanced Micro Devices, Inc.</sup></p>
