# Lab 4

In this lab exercise, you will learn how to efficiently implement designs with multiple data rates using multiple clock domains.

### Objectives
After completing this lab, you will be able to:
 * Understand the benefits of using multiple clock domains to implement multi-rate designs.
 * Understand how to isolate hierarchies using FIFOs to create safe channels for transferring asynchronous data.
 * How to implement hierarchies with different clocks.

### Procedure

This lab has three primary parts:
 * In Step 1, you will learn how to create hierarchies between the clock domains.
 * In Step 2, you will learn how to add FIFOs between the hierarchies.
 * In Step 3, you will learn how to add separate clock domains for each hierarchy.

## Step 1: Creating Clock Domain Hierarchies

In this step you will review a design in which different parts of the design operate at different data rates and partition the design into subsystems to be implemented in different clock domains.

1. Invoke Vitis Model Composer:
    - On Windows systems select **Windows > Xilinx Design Tools > Vitis Model Composer 2021.2.**
    - On Linux systems, type `model_composer` at the command prompt.

2. Navigate to the Lab4 folder: <samp> \HDL_Library\Lab4. </samp>

3. At the command prompt, type open `Lab4_1.slx.`
<br><br>This opens the Simulink design shown in the following figure. This design is composed of three basic parts:
    - The channel filter digitally converts the incoming signal (491.52 MSPS) to near baseband (61.44 MSPS) using a classic multi-rate filter: the use of two half-band filters followed by a decimation of 2 stage filter, which requires significantly fewer coefficients than a single large filter.
    - The output section gain-controls the output for subsequent blocks which will use the data.
    - The gain is controlled from the POWER_SCALE input.
    
<img src="Images/Step1/Step3.png">

4. Click the Run simulation button to simulate the design.
In the following figure Sample Time Display is enabled with colors (right-click in the canvas, **Sample Time Display > Colors**), and shows clearly that the design is running at multiple data rates.
<img src="Images/Step1/Step4.png">

5. The Vitis Model Composer environment automatically propagates the different data rates through the design.
<br><br>When a multi-rate design such as this is implemented in hardware, the most optimal implementation is to use a clock at the same frequency as the data; however, the clock is abstracted away in this environment. The following methodology demonstrates how to create this ideal implementation in the most efficient manner.

6. To efficiently implement a multi-rate (or multi-clock) design using Vitis Model Composer you should capture each part running at the same data rate (or clock frequency) in its own hierarchy with its own System Generator token. The separate hierarchies should then be linked with FIFOs.

7. The current design has two obvious, and one less obvious, clock domains:
    - The gain control input POWER_SCALE could be configurable from a CPU and therefore can run at the same clock frequency as the CPU.
    - The actual gain-control logic on the output stage should run at the same frequency as the output data from the FIR. This will allow it to more efficiently connect to subsequent blocks in the system.
    - The less obvious region is the filter-chain. Remember from Lab 1 that complex IP provided with Vitis Model Composer, such as the FIR Compiler, automatically takes advantage of over-sampling to provide the most efficient hardware. For example, rather than use 40 multipliers running at 100 MHz, the FIR Compiler will use only eight multipliers if clocked at 500 MHz (= 40\*100/500). The entire filter chain can therefore be grouped into a single clock domain. The first FIR Compiler instance will execute at the maximum clock rate and subsequent instances will automatically take advantage of over-sampling.
<br><br>You will start by grouping these regions into different hierarchies.

8. Select all the blocks in the filter chain – all those to be in the same clock domain, including the FDATool instances - as shown in the following figure.

9. Select Create Subsystem, also as shown in the following figure, to create a new subsystem.
<img src="Images/Step1/Step9.png">

10. Select the instance name subsystem and change this to DDC to obtain the design shown.
<img src="Images/Step1/Step10.png">

11. Select the components in the output path and create a subsystem named Gain Control.
<img src="Images/Step1/Step11.png">
     
12. Finally, select the Gateway In instance **POWER_SCALE** and **Constant** to create a new subsystem called CTRL. The final grouped design is shown in the following figure.
     
13. When this design is complete, the logic within each subsystem will execute at different clock frequencies. The clock domains might not be synchronous with each other. There is presently nothing to prevent incorrect data being sampled between one subsystem and another subsystem.
<br><br>In the next step you will create asynchronous channels between the different domains to ensure data will asynchronously and safely cross between the different clock domains when the design is implemented in hardware.     
     
## Step 2

In this step you will implement asynchronous channels between subsystems using FIFOs. The data in FIFOs operates on a First-In-First-Out (FIFO) basis, and control signals ensure data is only read when valid data is present and data is only written when there is space available. If the FIFO is empty or full the control signals will stall the system. In this design the inputs will always be capable of writing and there is no requirement to consider the case for the FIFO being full.

There are two data paths in the design where FIFOs are required:
 * Data from CTRL to Gain Control.
 * Data from DDC to Gain Control.

1. Right-click anywhere in the canvas and select **Xilinx BlockAdd**.

2. Type `FIFO` in the Add Block dialog box.

3. Select FIFO from the menu to add a FIFO to the design.

4. Connect the data path through instance FIFO. Delete any existing connections to complete this task.
    - Connect `CTRL/Out1` to `FIFO/din`.
    - Connect `FIFO/dout` to `Gain Control/In1`.

5. Make a copy of the FIFO instance (using Ctrl-C and Ctrl-V to copy and paste).

6. Connect the data path through instance FIFO1. Delete any existing connections to complete this task.
    - Connect `DDC/Out2` to `FIFO1/din`.
    - Connect `FIFO1/dout` to `Gain Control/In3`.
<br><br>You have now connected the data between the different domains and have the design shown in the following figure.
<img src="Images/Step2/Step6.png">
<br><br>You will now connect up the control logic signals to ensure the data is safely passed between domains.
    - From the CTRL block a write enable is required. This is not currently present and needs to be created.
    - From the DDC block a write enable is required. The data_tvalid from the final FIR stage can be used for this.
    - The Gain Control must generate a read enable for both FIFOs. You will use the empty signal from the FIFOs and invert it; if there is data available, this block will read it.


7. Double-click the **CTRL** block to open the subsystem.

8. Right-click in the canvas and use **Xilinx BlockAdd** to add these blocks:
    - Delay (Xilinx)
    - Relational

9. Select instance Out1 and make a copy (use Ctrl-C and Ctrl-V to cut and paste).

10. Double-click the **Relational** block to open the Properties Editor.

11. Use the Comparison drop-down menu to select **a!=b** and click **OK**.

12. Connect the blocks as shown in the following figure.
<br><br><img src="Images/Step2/Step12.png">
<br><br>This will create an output strobe on Out2 which will be active for one cycle when the input changes, and be used as the write-enable from CTRL to the Gain Control (the FIFO block at the top level).

13. Click the Up to Parent toolbar button <img width="18" height="18" src="../Images/Buttons/upToParent.png"> to return to the top level.

14. Double-click the instance Gain Control to open the subsystem.

15. Right-click in the canvas and use Xilinx BlockAdd to add these blocks:
    - Inverter
    - Inverter (for a total of two inverters)
    - Delay (Xilinx)

16. Select the instance Out1 and make a copy `Out3` (use Ctrl-C and Ctrl-V to cut and paste).
    - Rename Out3 to `DDC_Read`

17. Select instance Out1 and make a copy `Out3` (use Ctrl-C and Ctrl-V to cut and paste).
    - Rename Out3 to `CTRL_Read`

18. Select instance In1 and make a copy `In4` (use Ctrl-C and Ctrl-V to cut and paste).
    - Rename In4 to `CTRL_Empty`

19. Connect the blocks as shown in the following figure
<br><br><img src="Images/Step2/Step19.png"><br><br>
    - The FIFO empty signal from the top-level Gain Control FIFO (FIFO) block is simply an inverter block used to create a read-enable for the top-level DDC FIFO (FIFO1). If the FIFO is not empty, the data will be read.
    - Similarly, the FIFO empty signal from the top-level DDC FIFO (FIFO1) is inverted to create a FIFO read-enable.
    - This same signal will be used as the new `data_tvalid` (which was In2). However, because the FIFO has a latency of 1, this signal must be delayed to ensure this control signal is correctly aligned with the data (which is now delayed by 1 through the FIFO).

20. Use the Up to Parent toolbar button <img width="18" height="18" src="../Images/Buttons/upToParent.png"> to return to the top level.
<br><br>This shows the control signals are now present at the top level.
<br><br><img src="Images/Step2/Step20.png">
<br><br>You will now complete the final connections.

21. Connect the control path through instance FIFO. Delete any existing connections to complete this task.
    - Connect `CTRL/Out2` to `FIFO/we`.
    - Connect `FIFO/empty` to `Gain Control/CTRL_Empty`.
    - Connect `Gain Control/CTRL_Read` to `FIFO/re`.

22. Connect the control path through instance FIFO1. Delete any existing connections to complete this task.
    - Connect `DDC/Out1` to `FIFO1/we`.
    - Connect `FIFO1/empty` to `Gain Control/In2`.
    - Connect` Gain Control/DDC_Read` to `FIFO1/re`.
<br><br><img src="Images/Step2/Step22.png">

23. Click the Run simulation button to simulate the design and confirm the correct operation – you will see the same results as Step 1 action 4.

In the next step, you will learn how to specify different clock domains are associated with each hierarchy.

## Step 3: Specifying Clock Domains

In this step you will specify a different clock domain for each subsystem.

1. Double-click the System Generator token to open the Properties Editor.

2. Select the **Clocking** tab.

3. Click **Enable multiple clocks**

> 📝 **Note**: The FPGA clock period and the Simulink system period are now greyed out. This option informs Vitis Model Composer that clock rate will be specified separately for each hierarchy. It is therefore important the top level contains only subsystems and FIFOs; no other logic should be present at the top level in a multi-rate design.

<ul><img src="Images/Step3/Step3.jfif"></ul>

4. Click **OK** to close the Properties Editor.
<br><br>You will now specify a new clock rate for the CTRL block. The CTRL block will be driven from a CPU which executes at 100 MHz.

5. Select the **System Generator** token.

6. Press the Ctrl+C key or right-click to copy the token.
<br><br>You will specify a new clock rate for the CTRL block. This block will be clocked at 100 MHz and accessed using an AXI4-Lite interface.

7. Double-click the **CTRL** block to navigate into the subsystem.

8. Press the Ctrl+V key or right-click to paste a System Generator token into CTRL.

9. Double-click the **System Generator** token to open the Properties Editor.

10. Select the **Clocking** tab.

11. Deselect **Enable multiple clocks** (this was inherited when the token was copied).

12. Change the FPGA clock period to 1e9/100e6.

13. Change the Simulink system period to 1/100e6.
<br><br><img src="Images/Step3/Step13.png">

14. Click **OK** to close the Properties Editor.

15. Double-click the Gateway In instance **POWER_SCALE** to open the Properties Editor.

16. Change the Sample period to 1/100e6 to match the new frequency of this block.
<br><br>In the Implementation tab, note that the Interface is set to AXI4-Lite. This will ensure this port is implemented as a register in an AXI4-Lite interface.

17. Click **OK** to close the Properties Editor.

18. Select and copy the System Generator token.

19. Click the **Up to Parent** toolbar button to return to the top level.
<br><br>You will now specify a new clock rate for the Gain Control block. The Gain Control block will be clocked at the same rate as the output from the DDC, 61.44 MHz.

20. Double-click the **Gain Control** block to navigate into the subsystem.

21. Press the Ctrl+V key or right-click to paste a System Generator token into Gain Control.

22. Double-click the **System Generator** token to open the Properties Editor.

23. Select the **Clocking** tab.

24. Change the FPGA clock period to 1e9/61.44e6.

25. Change the Simulink system period to 1/61.44e6.
<br><br><img src="Images/Step3/Step25.png">

26. Click **OK** to close the Properties Editor.
<br><br>Note that the output signals are prefixed with `M_AXI_DATA_`. This will ensure that each port will be implemented as an AXI4 interface, because the suffix for both signals is a valid AXI4 signal name (`tvalid` and `tdata`).

27. Click the **Up to Parent** toolbar button to return to the top level.
<br><br>The DDC block uses the same clock frequency as the original design, 491 MHz, because this is the rate of the incoming data.

28. In the top-level design, select and copy the System Generator token.

29. Double-click the **DDC** block to navigate into the subsystem.

30. Press the Ctrl+V key or right-click to paste a System Generator token into the DDC.

31. Double-click the **System Generator** token to open the Properties Editor.

32. Select the **Clocking** tab.

33. Deselect **Enable multiple clocks**. The FPGA clock period and Simulink system period are now set to represent 491 MHz.
<br><br><img src="Images/Step3/Step33.png">

34. Click **OK** to close the Properties Editor.

35. Use the **Up to Parent** toolbar button to return to the top level.

36. Save the design.

37. Click the Run simulation button to simulate the design and confirm the same results as earlier.
<br><br>The design will now be implemented with three clock domains.

38. Double-click the top-level **System Generator** token to open the Properties Editor.

39. Click **Generate** to compile the design into a hardware description.

40. Click **Yes** to dismiss the simulation warning.

41. When generation completes, click **OK** to dismiss the Compilation status dialog box.

42. Click **OK** to dismiss the System Generator token.

43. Open the file <samp> \HDL_Library\Lab4\IPP_QT_MCD_0001\DDC_HB_hier\ip\hdl\lab4_1.vhd </samp> to confirm the design is using three clocks, as shown in the following.
```
entity lab4_1 is
  port (
     ctrl_clk : in std_logic;
     ddc_clk : in std_logic;
     gain_control_clk : in std_logic;
``` 

### Summary 

In this lab, you learned how to create separate hierarchies for portions of the design which are to be implemented with different clock rates. You also learned how to isolate those hierarchies using FIFOs to ensure safe asynchronous transfer of the data and how to specify the clock rates for each hierarchy.

The following <samp> solution </samp> directory contains the final Vitis Model Composer (\*.slx) files for this lab. The solution directory does not contain the IP output from Vitis Model Composer or the files and directories generated by Vivado.
```
/HDL_Library/Lab4/solution
```
* The results from Step 1 are provided in file <samp> Lab4_1_sol.slx </samp>
* The results from Step 2 are provided in file <samp> Lab4_2_sol.slx </samp>
* The final results from Step 3 are provided in file <samp> Lab4_3_sol.slx </samp>

