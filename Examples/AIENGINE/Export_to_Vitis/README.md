# Export AI Engine Design from Vitis Model Composer to Vitis

In this example, we will show how to export an AI Engine design into a 
Vitis system project after it has been simulated and validated in Vitis 
Model Composer.

In the early stages of the development cycle, it is critical to verify 
the functional behavior of the AI Engine kernels and graph. Vitis Model 
Composer is an ideal choice for testing and debugging at this level 
because of the speed of iteration and the high level of data visibility it 
provides the AI Engine developer.

To run on Versal hardware, the finished AI Engine design must be linked 
to data movers running on the PL and a host application running on the PS. 
This linking step, as well as the subsequent packaging of the finished 
hardware image, is accomplished via a Vitis system project.

**NOTE:** To perform basic hardware validation of an AI Engine design 
without a pre-existing Vitis project, refer to the Vitis Model Composer 
Hardware Validation Flow.

There are two ways to export an AI Engine design from Vitis Model 
Composer to a Vitis system project:

1. Export the AI Engine kernel source code and generated graph code and 
import into Vitis as a Vitis AIE Component.
2. Export the compiled AI Engine library (libadf.a) and import into Vitis 
as a Pre-Built Binary Component

This example will describe both approaches.

## Example System Design

The design that will be used is shown in the following figure:

![](./Images/lab8_system_diagram.png)

The AI Engine part of the design, consisting of the Interpolator, 
Polarclip, and Classifier kernels, is simulated by and generated from 
Vitis Model Composer.

This example assumes that a Vitis system project containing the PL data 
movers and PS application already exists. To see how to build the Vitis 
system project from scratch, see the AI Engine/Versal integration 
tutorial.

## Examine the AI Engine Design

Open and run the Vitis Model Composer testbench for the AI Engine part of 
the design.

```
open_system('aie_testbench');
sim('aie_testbench');
```

This model implements the AI Engine processing cascade using AIE Kernel 
blocks. The output of simulating the AI Engine processing cascade is 
compared to a reference output. The AI Engine output is also displayed on 
a scope. To see how the input and reference output data is loaded into 
Model Composer, go to the **Simulink toolstrip -> Modeling -> Model 
Settings -> Model Properties -> Callbacks -> PostLoadFcn**.

After simulating the processing chain and verifying its functionality, it 
can be exported to Vitis for integration into a larger project.

## Examine the Vitis Project

An example Vitis system project is provided with this example. To see how 
to build this Vitis system project from scratch, see the AI Engine/Versal 
integration tutorial.

To open the project in Vitis:

1. Open a Linux terminal in this example directory.
2. Execute the following commands:

This copies the Vitis project into a new workspace called `work` and 
opens the Vitis Unified IDE in that workspace. The Vitis Unified IDE 
appears.

The contents of the Vitis workspace are listed in the panel labeled 
**Work**. This workspace contains 4 items:

- A **host** application component to run on the PS.
- Data mover HLS components (**mm2s** and **s2mm**) to run on the PL.
- A **system_project** that contains the 3 PS and PL components.

1. Expand the **system_project** menu and go to **Settings -> 
vitis_sys.json**.

The System Project Settings are displayed. In the Components section, 
note the host application component and 2 HLS components discussed 
previously.

### System Project Configuration

It is necessary to do some basic configuration before attempting to build 
the System Project on your system. First, install the Linux kernel image 
and root filesystem for your platform by following . Then do the following 
to point this Vitis system project to their location:

1. Under System Project Settings -> system_project, click on Select 
Platform.

2. Select one of the base platforms installed on your system and click 
Save.

3. Under Package Settings, select Edit next to Kernel image.

4. Provide the path to a Linux kernel image file that you've installed on 
your system.

5. Repeat the previous 2 steps to provide the path to a Linux root 
filesystem file (.ext4 extension) installed on your system.

### Building the System Project

1. In the Flow pane, ensure that the **system_project** component is 
selected.
2. Under Software Emulation, click Build All.
3. Select all components to build and click OK.

The Vitis IDE will invoke the Vitis command line tool (v++) to:

1. Compile the HLS datamover kernels and the host application
2. Link the kernels and host application into an embedded system
3. Package the system in a binary container for software emulation

Confirm that the output console reads "Build finished successfully", and 
that the Build All option under Software Emulation has a green check mark.

Now that we have a Vitis system project that builds, we can bring an AI 
Engine component into the design from Vitis Model Composer. The AI Engine 
design can be incorporated into the Vitis system project in 2 ways: as an 
AI Engine component, or as a Pre-Built Binary component.

## Approach 1: Export to Vitis as an AIE Component

### Generate AI Engine Source Code in Model Composer

1. Double-click on the **Vitis Model Composer** **Hub** block.
2. Ensure that the Hub block is set-up as follows for the `ai_engine` 
subsystem. The **Create Testbench** option will generate input and 
reference output data files for use with the `aiesimulator`. Click 
**Generate**.

### Create AI Engine Component in Vitis

1. In Vitis, go to File -> New Component -> AIE.
2. Leave the component name and location as their defaults and click 
Next.
3. Click the Add files button next to Import Sources.
4. Browse to locate these files and add them to the source list: In1.txt, 
Out1.txt, ai_engine.cpp, ai_engine.h 
5. ai_engine.cpp will be automatically selected as the top-level file. 
Click Next.
6. Select the same platform you selected in the "System Project 
Configuration" step above. Click Next.
7. Click Finish.

The AI Engine Component now appears in the Workspace list, and the AI 
Engine Component Setting screen opens. The AI Engine Component is now 
available in the Vitis workspace. Next, it must be added to your System 
Project.

### Add AI Engine Component to Vitis System Project

1. In the Workspace list, expand the **system_project** menu and go to 
**Settings -> vitis_sys.json**.

## Approach 2: Export to Vitis as a Pre-built Binary Component

