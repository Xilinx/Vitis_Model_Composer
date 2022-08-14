# Lab 3: Debugging Imported C/C++-Code Using GDB Debugger

Model Composer provides the ability to debug `C/C++` code that has been 
imported as a block using the `xmcImportFunction` command, 
while simulating the entire design in Simulink® .

The debug flow in Vitis Model Composer is as follows:
1. Specify the debug tool using the xmcImportFunctionSettings command.
2. Launch the debugging tool.
3. Add a breakpoint in the imported function.
4. Attach to the MATLAB® process.
5. Start Simulink simulation.
6. Debug the imported function during simulation.

This lab has two steps:
 * Step 1 introduces you to the Optical Flow demo design example in GitHub. It shows you how to identify the custom library block, created using the `xmcImportFunction` feature.
 * Step 2 shows you how to debug `C/C++` code using the GDB tool.

For more details and information about how to create custom blocks, refer to the Vitis Model Composer User Guide (UG1483).

## Step 1: Set Up the Example to Debug the Import Function

1. Type the following at the MATLAB command prompt:
``` 
xmcOpenExamples();
```

2. Press **Enter**. A window opens to specify the folder location to download the examples from GitHub.
<br><br><img src="../Images/HLS/Lab3/Step1/Step2.png">

3. Click **Open** after choosing the location. Once the download completes, the HTML page opens.

4. Click **HLS Examples** under heading Table of Contents. This redirects you to the list of HLS Examples as shown. 

5. Click the **Optical Flow**. A description of the example displays.
<br><br><img src="../Images/HLS/Lab3/Step1/Step5.png">

6. Click Click **Open Design** at the top left corner. This opens the example design.


7. In the Vitis Model Composer examples dialog box, select **optical flow** and click **Open example.** This opens the example design. at the top left corner. This opens the example design.
<br><br><img src="../Images/HLS/Lab3/Step1/Step7.png">

8. Click on the **Lucas_Kanade** subsystem and press **Ctrl+U** to look under the mask.

9. Right-click on the **Lucas-Kanade** subsystem and select **Mask > Look Under Mask** to observe the calculating-roots block.
<br><br><img src="../Images/HLS/Lab3/Step1/Step9-1.png">

> 📝 **Note:** This block has been generated using the `xmcImportFunction` feature. Its function declaration can be seen by double-clicking on the block.

<ul><br><br><img src="../Images/HLS/Lab3/Step1/Step9-2.png"></ul>

10. To view the function definition of `calculating_roots`, navigate to the current folder in the MATLAB window and double-click on <samp> calculating_roots.h </samp>.
<br><br><img src="../Images/HLS/Lab3/Step1/Step10.png">

The setup is now ready for you to debug your `C/C++` code. In the next step, you will see how to debug the code using GDB tool debugger.

## Step 2: Debugging C/C++ Code Using GDB Debugger
 
1. Specify the debug tool using the `xmcImportFunctionSettings` command. At the MATLAB® command prompt, type the following command:
```
>> xmcImportFunctionSettings(‘build’, ‘debug’);
```
> ⭐ **Tip**: You can restore the release build environment, using the `release` value of the `build` option: `xmcImportFunctionSettings('build','release')`.

2. Press Enter to see the applied settings in command window, as shown in the following figure.
<br><br><img src="../Images/HLS/Lab3/Step2/Step2.png">
<br><br> Note the gdb link that you will use to invoke the debugger tool, and the MATLAB process ID that you will use to attach the process to the debugger.

3. Click on the **gdb** link, to invoke the Windows command prompt and launch gdb.
<br><br><img src="../Images/HLS/Lab3/Step2/Step3.png">

 4. At the Windows command prompt, use the following command to specify the breakpoint in the <samp> calculating_roots.h </samp> file where you want the code to stop executing. Press **Enter** to run the command.
```
(gdb) break calculating_roots.h:53 

```
> 📝 **Note**: The “53” in the above command, tells the GDB debugger to stop the simulation at line 53 of your program.

<ul><br><br><img src="../Images/HLS/Lab3/Step2/Step4.png"></ul>

5. Once the command runs, you can see a pending breakpoint in the command window. This is shown in the following figure.
<br><br><img src="../Images/HLS/Lab3/Step2/Step5.png">
<br><br>If you see any questions from GDB, answer “yes” and press Enter.

6. To attach the MATLAB process to the GDB debugger, type the following:
```
(gdb) attach <process_ID> 
```
<ul> Enter the <process ID you saw in step 2. For example “15972”. As soon as the MATLAB process is attached, the MATLAB application gets frozen and becomes unresponsive. 
<br><br><img src="../Images/HLS/Lab3/Step2/Step6.png"> </ul>
 
> 📝 **Note** : During the debug process, if prompted to press 'c' to continue, type 'c' and hit Enter.

7. Type `cont` at the Windows command prompt.
<br><br><img src="../Images/HLS/Lab3/Step2/Step7.png">

8. Now go to the Simulink® model and run the simulation by clicking the **Run** button.
<br><br><img src="../Images/HLS/Lab3/Step2/Step8.png">

9. The model takes some time to initialize. As the simulation starts, you see the simulation come to the breakpoint at line 53 in the Windows command prompt.
<br><br><img src="../Images/HLS/Lab3/Step2/Step9.png">
<br><br>Now, type the command list to view the lines of code around line 53.
```
(gdb) list
```

10. Now, type command step to continue the simulation one line to the next step.
```
(gdb) step
```

> ❗❗ **Important:** The following are some useful GDB commands for use in debugging:
> * (gdb) list
> * (gdb) next (step over)
> * (gdb) step (step in) * 
> * (gdb) print \<variable>
> * (gdb) watch \<variable>

11. Type `print r` to view the values of variables at that simulation step. This gives the result as shown in the following figure.
```
(gdb) print r
$1 = 421
```

12. You can try using more gdb commands to debug and once you are done, type `quit` to exit GDB, and observe that the Simulink model continues to run.

### Conclusion
In this lab, you learned:
 * How to use a third party debugger (GDB debugger) and control the debug mode using xmcImportFunctionSettings.
 * How to debug source code associated with your custom blocks using the GDB debugger, while leveraging the stimulus vectors from Simulink.









