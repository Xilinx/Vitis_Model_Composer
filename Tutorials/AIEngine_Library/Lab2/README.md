# Lab 2: Importing AI Engine Graphs

This section of the tutorial shows how to import AI Engine graphs into Vitis Model Composer, generate the code, and simulate using AI Engine SystemC simulation.

### Procedure

This lab has following steps:
 * In Step 1, you build your design by importing AI Engine Graph code in Vitis Model Composer.
 * In Step 2, you simulate the design.
 * In Step 3, you generate a graph code and simulate using AI Engine SystemC simulation.

## Step 1: Build an AI Engine Design using Graph Code

In this step you will import graph code (generated using the design in Lab 1) using the AIE Graph block available in the Model Composer AI Engine library and build a design.

1. In the MATLAB® Current Folder, navigate to <samp> AIEngine_Library/Lab2/ </samp> 

2. Double-click <samp> import_graph.slx </samp> to open the model. This is a model with a source and a sink and you will fill the design in-between.

3. From the Library Browser, select the AIE Graph block from the AI Engine library. Drag the block into the <samp> import_graph.slx </samp> file.
<br><br><img src="Images/Step1/Step3-1.png">
<br><br> You can also click on the canvas and start typing `AIE Graph`.
<br><br><img src="Images/Step1/Step3-2.png">

4. Double-click the block to open its parameters.
<br><br><img src="Images/Step1/Step4.png">

5. Update the block parameters as follows:
<br><br> **Graph header file(\*.h)**: <samp> aie_system.h </samp>
<br><br> **Graph class**: <samp>Aie_system</samp>
<br><br> **Graph search paths**: Either browse to locate the kernels or enter {`'./kernels/src', './kernels/inc', './include'`} as the parameter.
<br><br> **Preprocessor options**: Leave empty

6. Click **Import**. You will see the Progress window as shown in the following figure. Once complete, the AIE Graph block GUI interface will get updated.
<br><br><img src="Images/Step1/Step6-1.png">
<br><br><img src="Images/Step1/Step6-2.png">

7. Observe the Function tab in the AIE graph block parameters as shown.
<br><br><img src="Images/Step1/Step7.png">

8. Click **OK** and connect the AIE Graph block as shown in the following figure.

## Step 2: Simulate the Design

1. Click **Run**. You will get similar results as those in Lab 1 (Import AIE Kernel).
<br><br><img src="Images/Step2/Step1.png">

## Step 3: Code Generation and AI Engine SystemC Simulation

1. Create a subsystem for the graph block.
<br><br><img src="Images/Step3/Step1.png">

> 📝 **Note**: In this particular design scenario only one graph code is imported. But in a case where we have multiple graphs imported and connected, Vitis Model Composer automatically generates the top module which includes interconnections of all blocks.


2. Assign the subsystem name as `graph_sub`.

3. Drag the Vitis Model Composer Hub block from the library browser or simply click on the canvas and start typing `Model Composer Hub`.
<br><br><img src="Images/Step3/Step3.png">

4. Double-click the Vitis Model Composer Hub block and make changes as follows (Similar to those in Lab 1 - Import AIE kernel).
<br><br><img src="Images/Step3/Step4.png">

5. Click **Apply**, then click **Generate**.

6. The Simulation procedure is similar to that of Lab 1 (Import AIE Kernel). It also generates the Target directory (<samp> ./code </samp> in this case) under which you can see the top level graph code under <samp> code/src_aie </samp> directory and the code/data directory which contains the data logged from the Simulink design along with output from the AIE simulation.
<br><br><img src="Images/Step3/Step6.png">
 
 7. Notice the log in the Progress window after completion. Click **OK**.
<br><br><img src="Images/Step3/Step6.png">

### Conclusion

In this lab, you learned:
 * How to import AI Engine graph code into Vitis Model Composer.
 * How to generate the top level graph code using the Model Composer Hub block.
 * How to perform the AI Engine SystemC simulation.

The following solution directory contains the final Vitis Model Composer files for this lab.
 * <samp> AIEngine_Library/Lab2/Solution </samp>
