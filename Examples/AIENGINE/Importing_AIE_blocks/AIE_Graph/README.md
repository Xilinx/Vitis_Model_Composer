# Importing graph as a block

In this example we import a simple graph as a block into Model Composer. When you import a graph into Model Composer using the AIE Graph 
block, you need to create a .cpp file and instantiate the graph. You later have to specify this file in the block mask. For other 
examples of importing a graph into Model Compsoer, including when the you have a templatized graph, take a look here. 


## Knowledge nuggets

:bulb: Note the usage of the *Graph Search Paths* to specify the search paths.

:bulb: Note how you specify the platform in the .cpp file with this line *adf::simulation::platform<2,1> platform("\~", "\~", "~");*. The number of "~"s is equal to the total number of inputs and outputs.


![](images/graph_import.jpg)




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
