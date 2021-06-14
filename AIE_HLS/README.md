# AI Engine and HLS design
In Model Composer you can simulate designs with both AI Engine blocks and HLS Kernel blocks. We use the *HLS Kernel* block to import an HLS kernel into Model Composer as a block. To connect the AI Engine blocks to the HLS kernel block, in case the data types do not match, we use the *AIE to HLS* and *HLS to AIE* interface blocks.

![](images/interface_blocks.PNG)

## Knowledge nuggets
:bulb: In Model Composer, you can cosimulate HLS kernels and AI Engine blocks.

:bulb: The HLS kernel code should have stream interfaces. they also support Run-time Parameters (RTPs). 

![](images/screen_shot.png)

## Examples
- [A desgin with both AI Engine and HLS Kernel blocks](AIE_HLS)



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
