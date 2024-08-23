# Lab 2: Importing Code into Vitis Model Composer

Vitis Model Composer lets you import Vitis™ HLS library functions and user C/C++ code as custom blocks to use in your algorithm for both simulation and code generation.

The Library Import feature is a MATLAB function, `xmcImportFunction`, which lets you specify the required source files and automatically creates an associated block that can be added into a model in Simulink® .

This lab primarily has two parts:
 * In Step 1, you are introduced to the `xmcImportFunction` function, and walk through an example.
 * In Step 2, you will learn about the Vitis Model Composer feature that enables you to create custom blocks with function templates

For more details and information about other Model Composer features, see the Vitis Model Composer User Guide (UG1483).

# Step 1: Set up the Import Function Example

In the MATLAB Current Folder panel, navigate to ` HLS_Library\Lab2\Section1 ` folder.

1.  Double-click the `basic_array.cpp` and `basic_array.h` files to view the source code in the MATLAB Editor.
 
These are the source files for a simple `basic_array` function in `C++`, which calculates the sum of two arrays of size 4. You will import this function as a Vitis Model Composer block using the `xmcImportFunction` function. The input and output ports for the generated block are determined by the signature of the source function. Vitis Model Composer identifies arguments specified with the const qualifier as inputs to the block, and all other arguments as outputs.

> 📝**Note:**  For more details and other options for specifying the direction of the arguments, see the Vitis Model Composer User Guide 
> ([UG1483](https://docs.amd.com/r/en-US/ug1483-model-composer-sys-gen-user-guide)).

> ❗❗ **Important:**  You can use the `const` qualifier in the function signature to identify the inputs to the block or use the pragma `INPORT`.

In the case of the `basic_array` function, the `in1` and `in2` arguments are identified as inputs.

``` 
void basic_array(
   uint8_t out1[4], 
   const uint8_t in1[4], 
   const uint8_t in2[4])
``` 
  
2. To learn how to use the `xmcImportFunction` function, type `help xmcImportFunction` at the MATLAB command prompt to view the help text and understand the function signature.

3. Open the `import_function.m` MATLAB script, and fill in the required fields for the `xmcImportFunction` function in this way:

```
xmcImportFunction('basic_array_library', {'basic_array'}, 'basic_array.h', {'basic_array.cpp'}, {});
```

The information is defined as follows:

* **Library Name:** `basic_array_library`. This is the name of the Simulink library that is created with the new block.
* **Function Names:** `basic_array`. This is the name of the function that you want to import as a block.
* **Header File:** `basic_array.h`. This is the header file for the function.
* **Source Files:** `basic_array.cpp`. This is the source file for the imported function.
* **Search Paths:** This argument is used to specify the search path(s) for header files. In this example, there are no additional search paths to specify and hence you can leave it as { } which indicates none.

> 📝 **Note:** Look at import_function_solution.m in the solution folder for the completed version.

4. Run the `import_function.m` script from the MATLAB command line:

```
>>run('import_function.m')
```

Notice that a Simulink library model opens up with the generated block `basic_array`.

Save this Simulink library model.

5. Double-click the **basic_array** block, and look at the generated interface.

The following figure shows the Block Parameters dialog box for ` basic_array `

![](Images/Step1/Step5.png)

6. Open the ` test_array.slx ` model, which is just a skeleton to test the generated block.

7. Add the generated ` basic_array ` block into this model, then connect the source and sink blocks.

8. Simulate this model and observe the results in the display block.

## Step 2: Custom Blocks with Function Templates

In this step we will walk through an example to do the following:
 * To create a custom block that supports inputs of different sizes.
 * To create a custom block that accepts signals with different fixed-point lengths and fractional lengths.
 * To perform simple arithmetic operations using template variables.

1. Navigate to the ` HLS_Library/Lab2/Section2 ` folder and open **design.slx**.

2. Double-click the **template_design.h** file to view the source code in the MATLAB Editor. There are two functions: Demux and Mux. These two functions are a demultiplexing and multiplexing of inputs as shown in the following figure.

![](Images/Step2/Step2.png)

3. In the piece of code, note the `#pragma XMC INPORT vector_in`. This is a way to manually specify port directions using pragmas. Here, we are specifying the function argument `vector_in` as the input port. Similarly, we can define `XMC OUTPORT` also.

> 📝 **Note**: For additional information about specifying ports, see Vitis Model Composer User Guide ([UG1483](https://docs.amd.com/r/en-US/ug1483-model-composer-sys-gen-user-guide)).

4. Notice the use of template before the function declaration. To support the inputs of different sizes, `NUMOFELEMENTS` is declared as a parameter and used the same while defining an array `vector_in` as shown in the following figure. This allows you to connect signals of different sizes to the input port of the block.

![](Images/Step2/Step4.png)

5. Notice the template parameters `W` and `I` which are declared to accept signals with different word lengths and integer lengths.

![](Images/Step2/Step5.png)

6. Observe the arithmetic operations performed using template variables as shown below, indicating the output signal length is half of the input signal length.

7. Similar explanation follows for Mux function.

![](Images/Step2/Step7-1.png)

Now create the library blocks for Mux and Demux functions using the `xmcImportFunction` command and complete the design below with custom blocks.

![](Images/Step2/Step7-2.png)

8. Double-click the **import_function.m** script file in the MATLAB command window and observe the following commands that generate library blocks to embed into your actual design.
```
>>xmcImportFunction('design_lib',{'Demux'},'template_design.h',{},{},'override','unlock')
>>xmcImportFunction('design_lib',{'Mux'},'template_design.h',{},{},'override','unlock')
```

> 📝 **Note**: The same library is specified for both the functions.

9. Run the ` import_function.m ` script from the MATLAB command line:
```
>>run('import_function.m')
```

10. Observe the generated library blocks in the ` design_lib.slx ` library model file and save it to working directory.

![](Images/Step2/Step10.png)

11. Copy the Demux and Mux blocks and paste them in the ` design.slx ` file and connect them as shown in the following figure.

![](Images/Step2/Step11.png)

12. Note the following after embedding the custom blocks:
    - Double-click the Constant block and observe the vector input of type double. SSR is a workspace variable, initially set to 8 from the initFcn model callback.
    - Using the Data Type Conversion (DTC) block, double type is converted to fixed type with 16-bit word length and 8-bit fractional length. <br> Input is configurable to any word length since the design is templatized.
    - Double-click the Demux block and observe the Template parameters section and Dimension column in the Interface section of the function tab.

![](Images/Step2/Step12.png)

13. Add a Display block at the input and output as shown in the following figure and simulate the model to observe the results.

![](Images/Step2/Step13.png)

14. To understand how templatized inputs add advantage and flexibility to your design, perform the following:
    - Double-click the input **DTC** block.
    - In the Block Parameters dialog box, change the Word length from 16 to 32.
    - Change the Fractional length from 8 to 16. 

![](Images/Step2/Step14-1.png)

15. Click **OK** and press **Ctrl+D**. Observe the signal dimensions in the design. 

![](Images/Step2/Step14-2.png)

To make sure the output is correct, run the simulation and observe that the same block can still be used in a generic way for different values of Word length and Fractional length. This is possible only because we have templatized the W and I values in our C design.

16. For an additional understanding of template parameters, perform the following:
    - Right-click the canvas and select **Model Properties**.
    - In the Model Properties window, click the **Callbacks** tab and select **initFcn** and edit the SSR value from 8 to 16 as shown in the following figure. ![](Images/Step2/Step15-1.png)
    - Click **OK** and press **Ctrl+D** to observe the change in the number of elements in the Constant block output vector. The bitwidth changes when we change the datatype on the input DTC. This is possible only because of the template parameter `NUMOFELEMENTS`. 

![](Images/Step2/Step15-2.png)

17. Run the simulation and validate the output according to the input values.

### Conclusion

In this lab, you learned:
 * How to create a custom block using the `xmcImportFunction` in Vitis Model Composer.
 * How to create a block that accepts signals with different fixed-point lengths and fractional lengths.
 * How to use the syntax for using a function template that lets you create a block that accepts a variable signal size or data dimensions.
 * How to perform simple arithmetic operations using template variables.

The following solution directory contains the final Vitis Model Composer (` *.slx `) files for this lab.
 * ` \HLS_Library\Lab2\Section1\solution `
 * ` \HLS_Library\Lab2\Section2\solution `


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
