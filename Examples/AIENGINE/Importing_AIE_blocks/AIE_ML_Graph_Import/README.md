# Importing AIE-ML graph into Vitis Model Composer as a block
## What is AI Engine-ML?
The AI Engine-ML architecture is optimized for machine learning, enhancing both the compute core and memory architecture. These devices are capable of both ML and advanced signal processing.
To learn more about the AIE-ML devices, refer to [this](https://docs.xilinx.com/r/en-US/am020-versal-aie-ml) documentation.

The AIE-ML Memory tile is introduced in the AIE-ML architecture to significantly increase the on-chip memory inside the AIE-ML array. This new functional unit reduced the utilization of PL resources including block RAMs and URAMs. 

<img src="./images/AIE_ML.jpg" width="500"/>

## Imported graph code
The screenshot below depicts the graph code [MultiGrpah.h](./src/MultiGraph.h) we are importing using the AIE-Graph import block in Vitis Model Composer. Here we are setting up two shared buffers, two for the input and one for the output.

<img src="./images/AIE_ML_graph.jpg" width="800"/>

