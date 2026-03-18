# Lab 6: Using a Vitis Model Composer HDL Design with a Zynq-7000 SoC

In this lab, you will learn how to export your Vivado® design with Vitis Model Composer HDL IP to a software environment and use driver files created by Vitis Model Composer to quickly implement your project on an AMD evaluation board, running hardware with software in the same design.

### Objectives

After completing this lab, you will have learned:

* How to export your Vivado design with Vitis Model Composer HDL IP to a software environment (Vitis™ software platform).
* How Vitis Model Composer automatically creates software driver files for AXI4-Lite interfaces.
* How to integrate the Vitis Model Composer driver files into your software application.

### Procedure

This lab has two primary parts:

* In Step 1, you will review the AXI4-Lite interface and associated C drivers.
* In Step 2, you will export your Vivado design to a Vitis software environment and run it on a board.

## Step 1: Review the AXI4-Lite Interface Drivers

In this step you review how AXI4-Lite interface drivers are provided when a design with an AXI4-Lite interface is saved. This exercise uses the same design as Lab 5: Using AXI Interfaces and IP Integrator.

1. Invoke Vitis Model Composer and use the **Current Folder** browser to change the directory to: `\HDL_Library\Lab6`.

2. At the command prompt, type open Lab6_1.slx. This opens the design as shown in the following figure.

![](Images/Step1/Step2.png)

This design uses a number of AXI interfaces. These interfaces were reviewed in Lab 5: Using AXI Interfaces and IP Integrator and the review is repeated here with additional details on the AXI4-Lite register addressing.

Using AXI interfaces allows a design exported to the Vivado IP Catalog to be efficiently integrated into a larger system using IP integrator. It is not a requirement for designs exported to the IP Catalog to use AXI interfaces. 

An AXI4-Stream interface is used for ports `s_axis_source_*`. All Gateway In and Out signals are prefixed with same name (`s_axis_source_`) ensuring they are grouped into the same interface. The suffix for all ports are valid AXI4-Stream interface signal names (`tvalid`, `tlast`, and `tdata`).

3. Double-click **Gateway In** decrypt (or any of **reset**, **Keys[63:32]**, **Keys[31:0]**, **parity_err**).

4. In the Properties Editor select the **Implementation** tab.

5. Confirm the Interface is specified as AXI4-Lite in the Interface options. Also note how the address of this port may be automatically assigned (as the current setting of **Auto assign address offset** indicates), or the address may be manually specified.

6. Click **OK** to exit the Properties Editor.

Details on simulating the design are provided in the canvas notes. For this exercise, you will concentrate on exporting the design to the Vivado IP catalog and use the IP in an existing design.

7. In the Model Composer Hub block, select **Export** from the Export tab to generate a design in IP Catalog format.

8. Click **OK** to dismiss the Progress dialog box.

9. Click **OK** to dismiss the Model Composer Hub.

10. In the file system, navigate to the directory `./netlist/ip/HDL_DUT/src/ip/drivers/HDL_DUT_v1_0/src` and view the driver files.

The driver files for the AXI4-Lite interface are automatically created by Vitis Model Composer when it saves a design in IP Catalog format.

11. Open file `hdl_dut_hw.h` to review which addresses the ports in the AXI4-Lite interface were automatically assigned.

![](Images/Step1/Step11.png)

12. Open file `hdl_dut.c` to review the C code for the driver functions. These are used to read and write to the AXI4-Lite registers and can be incorporated into your C program running on the Zynq®-7000 CPU. The function to write to the decrypt register is shown below.

```
#include "hdl_dut.h"
#include "xstatus.h"
#include <assert.h>

#ifndef __linux__
int hdl_dut_CfgInitialize(hdl_dut * InstancePtr, hdl_dut_Config * Config,
			UINTPTR EffectiveAddr)
{
	/* Assert arguments */
	Xil_AssertNonvoid(InstancePtr != NULL);

	/* Set some default values. */
	InstancePtr->BaseAddress = EffectiveAddr;

	/*
	 * Indicate the instance is now ready to use, initialized without error
	 */
	InstancePtr->IsReady = XIL_COMPONENT_IS_READY;
	return (XST_SUCCESS);
}
#endif
void hdl_dut_reset_write(hdl_dut *InstancePtr, u32 Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    hdl_dut_WriteReg(InstancePtr->BaseAddress, 0, Data);
}
u32 hdl_dut_reset_read(hdl_dut *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = hdl_dut_ReadReg(InstancePtr->BaseAddress, 0);
    return Data;
}
void hdl_dut_decrypt_write(hdl_dut *InstancePtr, u32 Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    hdl_dut_WriteReg(InstancePtr->BaseAddress, 4, Data);
}
u32 hdl_dut_decrypt_read(hdl_dut *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = hdl_dut_ReadReg(InstancePtr->BaseAddress, 4);
    return Data;
}
void hdl_dut_key_63_32_write(hdl_dut *InstancePtr, u32 Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    hdl_dut_WriteReg(InstancePtr->BaseAddress, 8, Data);
}
u32 hdl_dut_key_63_32_read(hdl_dut *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = hdl_dut_ReadReg(InstancePtr->BaseAddress, 8);
    return Data;
}
void hdl_dut_key_31_0_write(hdl_dut *InstancePtr, u32 Data) {

    Xil_AssertVoid(InstancePtr != NULL);

    hdl_dut_WriteReg(InstancePtr->BaseAddress, 12, Data);
}
u32 hdl_dut_key_31_0_read(hdl_dut *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = hdl_dut_ReadReg(InstancePtr->BaseAddress, 12);
    return Data;
}
u32 hdl_dut_parity_err_read(hdl_dut *InstancePtr) {

    u32 Data;
    Xil_AssertVoid(InstancePtr != NULL);

    Data = hdl_dut_ReadReg(InstancePtr->BaseAddress, 16);
    return Data;
}
```

The driver files are automatically included when the Vitis Model Composer design is added to the IP Catalog. The procedure for adding a Vitis Model Composer design to the IP Catalog is detailed in Lab 5: Using AXI Interfaces and IP Integrator. In the next step, you will implement the design.

## Step 2: Developing Software and Running it on the Zynq-7000 System

1. Open the Vivado IDE:
    - Click **Windows > Vivado 2025.2.**
In this lab you will use the same design as Lab 5: Using AXI Interfaces and IP Integrator, but this time you will create the design using a Tcl file, rather than the interactive process.

2. Using the Tcl console as shown in the following figure:
   - Type `cd IPI_Project` to change to the project directory.
   - Type source lab6_design.tcl to create the RTL design.

> 📝 Note: If you have copied the tutorials to a different directory or changed the file names, you should update the Tcl file accordingly.

![](Images/Step2/Step2.png)

3. Click **Open Implemented Design** in the Flow Navigator pane.

4. From the Vivado IDE main menu select **File > Export > Export Hardware**.

5. Click **Next** in the Export Hardware Platform page.

![](Images/Step2/Step5.png)

6. Select the **Include Bitstream** option in the Output page and click Next.

![](Images/Step2/Step6.png)

7. Leave the **XSA file name** and the **Export to** fields at the default setting and click **Next**.

8. Click **Finish** to export the hardware.

9. Open the Vitis Unified IDE:
    - Click **Windows > Vitis 2025.2.**

10. Select the workspace space directory to store preferences and click Launch.

11. From the Vitis IDE, select **Create Platform**.

12. Enter the platform component name `Design1_Platform` in the Component name field.

![](Images/Step2/step16_.png)

13. Click **Next**.

14. Select **Hardware Design** and click Browse to create a custom platform from the XSA.

15. Navigate to Lab6 > IPI_Project > project_1, select design_1_wrapper.xsa and click Open.

![](Images/Step2/Platform_Flow.png)

17. Click **Next**.
    
18. Confirm the operating system and the processor are selected according to the image below. Enable the **Generate boot artifacts** checkbox.

![](Images/Step2/step17_.png)

19. Click **Next**.

20. Click **Finish**.

![](Images/Step2/Platform_Creation.PNG)

21. Platform is created. Select the build icon in the flow view to build the platform.

The platform will begin building in the background and we can move on to Create Application.

![](Images/Step2/step20_.png)

**Creating Application**

22. The user can view the available application templates from the Top menu by selecting View and Examples.

This will show a list of available examples in the explorer view. We can select the Hello World example as shown below:

![](Images/Step2/Creating_Application.png)

23. Give application name as 'Des_Test' and click next.

Select the target that was created and built above.

![](Images/Step2/add_application_name.png)

![](Images/Step2/Select_Platform_For_Application.png)

24. Choose the existing domain that was created in the platform.

![](Images/Step2/Choose_Domain.png)

**Build Application and Deploy on Target**

25. Power up the ZC702 board to program the FPGA.

26. We are now ready to build our application Des_Test. To do this, select the Build icon in the Flow view.

![](Images/Step2/application_build.png)

27. Click **Vitis > Program Device** and from the resulting window, click **Program**.

![](Images/Step2/program_device.png)
![](Images/Step2/program_device_app.png)
![](Images/Step2/programmed_device_.png)

28. Click **Create Boot Image** and specify a file path to save BOOT.bin file.
    
![](Images/Step2/BootImage.png)

29. Click **Vitis > Program Flash** and include BOOT.bin file during flash. Click **Program**.
![](Images/Step2/ProgramFlash.png)
![](Images/Step2/Flash.png)

30. Click **Run** after program flash is successful. Switch to the terminal tab and confirm that `Hello World` was received.

![](Images/Step2/HelloWorld_Program.png)

31. Expand the container `Des_Test` and then expand the container `src`.

32. Double-click the **helloworld.c** file.

33. Replace the contents of this file with the contents of the file `hello_world_final.c` from the `lab6` directory.

34. Save the `helloworld.c` source code.

35. Build the application. Once the build is successful then click on program device.

36. Generate BOOT.bin file and program flash.

37. Click **Run** after program flash is successful and review the results in the terminal (shown in the following figure).
    
![](Images/Step2/final_output.png)
![](Images/Step2/Hello_World_Final_Flash.png)

### Summary 

In this lab, you learned how to export your Vivado IDE design containing Vitis Model Composer HDL IP to the Vitis software environment and to integrate the driver files automatically created by Vitis Model Composer to run the application on the ZC702 board. You then viewed the results of the acceleration.

The following solutions directory contains the final Vitis Model Composer (`*.slx`) files for this lab. The solutions directory does not contain the IP output from Vitis Model Composer, the files and directories generated when the Vivado IDE is executed, or the Vitis workspace.

`\HDL_Library\Lab6\solution`

--------------
Copyright (c) 2025 Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
