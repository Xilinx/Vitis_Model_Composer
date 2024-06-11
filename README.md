![](Images/github_banner.png)

# Rapid design exploration using Vitis Model Composer<a name="introduction"></a>

Within the Simulink environment, Vitis Model Composer offers a range of performance-optimized blocks that facilitate the design and implementation of DSP algorithms on AMD devices. The inclusion of the Vitis Model Composer AI Engine, HLS, and HDL libraries enables efficient algorithm exploration and greatly expedites the path towards production.

To learn more, visit the Vitis Model Composer [website](https://www.xilinx.com/products/design-tools/vitis/vitis-model-composer.html).

# Where should you start?
Are you interested in accelerating your development effort using Vitis Model Composer? Here is where to start:
* **Review the [supported operating systems and MATLAB releases](https://github.com/Xilinx/Vitis_Model_Composer/wiki/System-Requirements-for-Vitis-Model-Composer).**
* Learn the [basics](/Tutorials/Simulink_Basics/README.md) of Simulink. To use Vitis Model Composer effectively, you need to understand the basics of Simulink, 
a block diagram environment for multidomain simulation and model-based design.
* Go over to the [tutorials](/Tutorials/README.md). The tutorials will give you a solid understanding of how to use the tool.
* Browse through many of the examples we have here. You can easily access these examples from within the tool. (**Note:** Many of the examples require the [DSP System Toolbox](https://www.mathworks.com/products/dsp-system.html).)


# What's new in 2024.1?
* The [Normalization example](./Examples/AIENGINE/Normalization) showcases two features of the AIE-ML architecture: shared buffers on memory tiles, and the `bfloat16` data type.
* See a [64K-pt IFFT at 2 GSPS](./Examples/AIENGINE_plus_PL/AIE_HLS/IFFT64K_2D) implemented in AI Engine using a 2D architecture.
* Working with both AI Engines and PL? See the [tutorials](./Tutorials/AIE-PL/README.md) showing how to connect the block libraries in Vitis Model Composer.
* MATLAB R2023a and R2023b are now supported by Vitis Model Composer.

# Examples

<p align="center">
  <a href="./Examples/AIENGINE_plus_PL/README.md"><img src="Images/hetero.jpg" width="350"></a>  
  <a href="./Examples/AIENGINE/README.md"> <img src="Images/aiengines.jpg" width="350"></a>
  <a href="./Examples/HLS/README.md"><img src="Images/hls.jpg" width="350"></a>
  <a href="./Examples/HDL/README.md"><img src="Images/hdl.jpg" width="350"></a>
</p>

# Tutorials
<p align="center">
   <a href="./Tutorials/README.md"><img src="Images/tutorials.jpg" width="350" ></a>
</p>
    
# Quick Guides<a name="quick_guides"></a>
<p align="center">
   <a href="./QuickGuides/README.md"><img src="Images/QuickGuides.jpg" width="350" ></a>
</p>

--------------
Copyright 2024 Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
