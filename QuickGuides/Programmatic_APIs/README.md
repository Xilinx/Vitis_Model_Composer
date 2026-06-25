# Programmatic APIs for AIE Kernel, Graph Blocks, and HLS Kernel

This guide shows how to **automatically configure AI Engine and HLS kernel blocks** in your Simulink model using MATLAB code, instead of manually clicking through dialog boxes. This is useful when you:
- Need to set up many blocks quickly
- Want to automate your design workflow
- Are building scripts to generate models programmatically
- Need to apply the same configuration to multiple blocks

This guide covers four types of blocks:
- **AIE Kernel** — Simple AI Engine function
- **AIE Class Kernel** — AI Engine function organized in a class
- **AIE Graph** — Graph of connected AI Engine kernels
- **HLS Kernel** — High-Level Synthesis kernel for Programmable Logic (PL)

## Key Concepts

### What is vmcGetBlockInfo / vmcSetBlockInfo? (Recommended Approach)
**vmcGetBlockInfo** and **vmcSetBlockInfo** are the primary programmatic surface for configuring kernel blocks. The recommended workflow is:
```matlab
% Get the current block configuration as a struct
% 1) Get the current block configuration as a NESTED struct
info = vmcGetBlockInfo(blk);

% 2) General settings (file paths, function name) live under info.General
info.General.KernelHeaderFile = 'mykernel.h';
info.General.KernelFunction   = 'my_func';
vmcSetBlockInfo(blk, info);

% 3) Import to discover ports, then set port attributes via the info.Ports
%    struct array (ports only exist after import). Set only editable fields.
vmcImportSource(blk);
info = vmcGetBlockInfo(blk);
info.Ports(1).WindowSize = '32';
vmcSetBlockInfo(blk, info);   % atomic commit of dependent parameters
```
The `info` struct is **nested**: general parameters are under `info.General.*`, port
attributes are the `info.Ports` struct array (`Direction, Name, Type, WindowSize,
WindowMargin, Synchronicity, SignalSize`), template parameters are `info.TemplateParams`
(`Name, Type, Value`), and HLS port directions are `info.PortDirectionTable`
(`Name, Type, Direction, Interface`). Assigning flat fields such as `info.KernelHeaderFile`
or `info.PortAttrs` is silently ignored, so always use the nested fields shown above.
This struct round-trip approach ensures all dependent parameters are updated consistently.

**Note on set_param (Equivalent Shortcut):**  
`set_param` is also supported and works identically. The difference is that `set_param` updates one parameter at a time. For dependent parameters, prefer vmcSetBlockInfo to ensure atomic updates.

### What is set_param?
`set_param` is a MATLAB function that sets properties on Simulink blocks. Instead of opening a dialog box and typing values, you pass them directly in code. For independent parameters this is fine; for dependent parameters, use vmcSetBlockInfo instead.

### What is vmcImportSource?
This function reads your kernel source code (C/C++) and discovers what ports (inputs/outputs) and parameters your kernel has. **You must run this after setting the file paths** so the tool knows what to import.

### What is vmcBuildSource?
This function compiles your kernel code. For **HLS and AIE Graph blocks**, this is required. For simple **AIE Kernels**, it's optional.

## Important Syntax Notes
**Atomic Commits for Dependent Parameters:**  
When setting dependent parameters (e.g., port attributes alongside file paths, or function template parameters), use **vmcSetBlockInfo** to commit changes atomically. Setting dependent parameters individually with `set_param` may leave the block in an inconsistent state. Always group related parameters in one vmcSetBlockInfo call.
**MATLAB String Arrays:**  
When specifying file paths or data structures, MATLAB requires special syntax:
- Single paths: `'filename.h'`
- Multiple paths: `"{'./path1', './path2'}"` (curved braces inside quotes)
- Compiler options: `"{'-DOPTION1', '-DOPTION2'}"`
- Port definitions: `"{ 'col1', 'col2'; 'col3', 'col4' }"` (semicolon separates rows)

> **Note:** Keep a table/cell string such as `PortAttrs` or `PortDirectionTable` on a **single line**. MATLAB does not allow `...` line continuation *inside* a double-quoted string literal, so splitting one of these strings across lines raises `String is not terminated properly`. (Alternatively, build the configuration with the `vmcGetBlockInfo`/`vmcSetBlockInfo` struct round-trip described above, which avoids long inline strings entirely.)

**Example:**
```matlab
% Single value
'kernels.h'

% List of paths
"{'./kernels', './include'}"

% 2x3 table (3 columns, 2 rows)
"{ 'input', 'int32', 'port1'; 'output', 'int32', 'port2' }"
```

## Common Workflow

1. **Add a block** to your model using `add_block()`
2. **Set file paths and options** using `set_param()` (KernelHeaderFile, KernelSourceFile, etc.)
3. **Import the source** using `vmcImportSource()` — this reads your C/C++ code
4. **Configure ports** by setting port attributes using `set_param()` again
5. **Build the kernel** using `vmcBuildSource()` (required for HLS and AIE Graph, optional for AIE Kernel)
6. **Check for errors** using status values returned by import/build functions

**Quick Reference:**
```matlab
% Step 1: Add block
blk = 'my_model/my_kernel';
add_block('XilinxModelComposer/AI Engine/User-Defined Functions/AIE Kernel', blk);

% Step 2: Set file paths
set_param(blk, 'KernelHeaderFile', 'mykernel.h', 'KernelFunction', 'my_func');

% Step 3: Import
status = vmcImportSource(blk);
if ~status.success
    error('Import failed: %s', status.message);
end

% Step 4: Configure ports
set_param(blk, 'PortAttrs', "{ 'input', 'i1', 'input_window_int32 *', '32', ... }");

% Step 5: Build (if needed)
status = vmcBuildSource(blk);
```

## AIE Kernel

An **AIE Kernel** is a single C/C++ function that runs on the AI Engine. Use this when your computation is a simple function (not organized in a class).

### Required Parameters

| Parameter | What It Is | Example |
|-----------|-----------|---------|
| `KernelHeaderFile` | C/C++ header file containing the function declaration | `'kernels.h'` |
| `KernelFunction` | Name of the function to import | `'simple'` |
| `KernelSourceFile` | C/C++ source file containing the function implementation | `'kernels/kernels.cc'` |
| `KernelSearchPaths` | Folder paths where the compiler should look for include files | `"{'./kernels'}"` |

### Optional Parameters

| Parameter | What It Does |
|-----------|-------------|
| `KernelInitFunction` | A function that initializes your kernel (runs once at startup) |
| `PreProcOptions` | Compiler flags/options, like `-DBUFFER_DEPTH=1024` |

### Workflow

1. Set the file paths using `set_param()`
2. Call `vmcImportSource()` — this reads your C/C++ code and discovers the function signature
3. Set port attributes (input/output sizes)

**Do I need vmcBuildSource?** Usually not for AIE Kernel — the import step is usually enough.

### Example — Window Kernel with Compiler Options

This example imports a kernel that processes data using a sliding window:

```matlab
blk = 'AIE_kernel_import/aie_kernel';
add_block('XilinxModelComposer/AI Engine/User-Defined Functions/AIE Kernel', blk);

% Step 1: Get the current block configuration (struct-based approach - RECOMMENDED)
info = vmcGetBlockInfo(blk);

% Step 2: Set file paths and options under info.General
info.General.KernelHeaderFile  = 'kernels.h';
info.General.KernelFunction    = 'simple';
info.General.KernelSourceFile  = 'kernels/kernels.cc';
info.General.KernelSearchPaths = "{'./kernels'}";
info.General.PreProcOptions    = '{''-DBUFFER_DEPTH=1024''}';

% Step 3: Apply all changes atomically
vmcSetBlockInfo(blk, info);

% Step 4: Import to discover ports
status = vmcImportSource(blk);
assert(status.success, 'vmcImportSource failed: %s', status.message);

% Step 5: Set port attributes via the info.Ports struct array.
% Port names/types are read from the source; set only the editable fields
% (here, the input/output window sizes).
info = vmcGetBlockInfo(blk);
info.Ports(1).WindowSize = '32';   % input 'in'
info.Ports(2).WindowSize = '32';   % output 'out'
vmcSetBlockInfo(blk, info);
```

**Alternative with set_param (shortcut):**  
For independent parameters, you can also use `set_param`:
```matlab
set_param(blk, 'KernelHeaderFile', 'kernels.h', 'KernelFunction', 'simple', ...);
```

**Explanation:**
- Added a new AIE Kernel block to the model
- Retrieved the block configuration as a nested struct and set the file paths under `info.General`
- Applied the path changes with `vmcSetBlockInfo`
- Imported the kernel — the tool read `kernels.h` to find the function signature and populated `info.Ports`
- Retrieved the struct again, set the editable port fields (`WindowSize`) on `info.Ports`, and committed atomically


**Port Attributes Breakdown:**
```
{ 'Direction',  'Name',  'Type',                  'WindowSize', 'WindowMargin', 'Synchronicity', 'SignalSize' }
  'input',      'in',    'input_window_cint32 *', '32',         '0',            'sync',          ''
  'output',     'out',   'output_window_cint32 *','32',         '',             'sync',          ''
```
- **Direction**: `'input'` or `'output'`
- **Name**: Port name in your C code
- **Type**: C++ type (window pointer for window kernels)
- **WindowSize**: Window size in samples
- **WindowMargin**: Initial margin (usually 0 for input)
- **Synchronicity**: `'sync'` (synchronized) or `''` (asynchronous)
- **SignalSize**: Signal size indicator (usually empty for windows)


## AIE Class Kernel

An **AIE Class Kernel** is a C++ class with a member function that runs on the AI Engine. Use this when your kernel is organized as a class (more structured than a simple function). Classes can also have **Runtime Parameters (RTPs)** — values you can change while the design is running.

### Required Parameters

| Parameter | What It Is | Example |
|-----------|-----------|---------|
| `KernelHeaderFile` | C/C++ header file containing the class definition | `'src/kernels.h'` |
| `KernelClassName` | Name of the class | `'MyKernel'` |
| `KernelFunction` | Name of the member function to call | `'myFunc'` |
| `KernelSourceFile` | C/C++ source file with the class implementation | `'src/kernels.cpp'` |
| `KernelSearchPaths` | Folders where the compiler looks for includes | `"{'.','src'}"` |

### Optional Parameters

| Parameter | What It Does |
|-----------|-------------|
| `PreProcOptions` | Compiler flags, like `-DBUFFER_DEPTH=1024` |

### Workflow

1. Set the class and file paths using `set_param()`
2. Call `vmcImportSource()` — reads your C++ code and discovers the class structure and member function
3. Set port attributes, including any runtime parameters (RTPs)

### Example — Stream Kernel with Runtime Parameter

This example shows a class kernel with:
- An **input stream** (continuous data flow)
- An **output stream** (continuous data flow)
- An **RTP** (Runtime Parameter) — a value you can change without recompiling

```matlab
blk = 'AIE_class_kernel_import/aie_class_kernel';
add_block('XilinxModelComposer/AI Engine/User-Defined Functions/AIE Class Kernel', blk);

% Step 1: Point to the class source code
set_param(blk, ...
    'KernelHeaderFile',   'src/kernels.h', ...
    'KernelClassName',    'MyKernel', ...           % The C++ class name
    'KernelFunction',     'myFunc', ...             % The member function name
    'KernelSourceFile',   'src/kernels.cpp', ...
    'KernelSearchPaths',  "{'.','src'}", ...
    'PreProcOptions',     "{'-DBUFFER_DEPTH=1024'}");

% Step 2: Import the class structure
status = vmcImportSource(blk);
assert(status.success, 'vmcImportSource failed: %s', status.message);

% Step 3: Configure ports and RTP
% Format: { Direction, Name, Type, WindowSize, WindowMargin, Synchronicity, SignalSize }
% Note: Streams don't have a window size (4th column is empty '').
% The table must be a single-line string -- MATLAB does not allow '...'
% line continuation inside a double-quoted string literal.
pa = "{ 'input', 'i1', 'input_stream_cint32 *', '', '0', '', ''; 'output', 'o1', 'output_stream_cint32 *', '', '', '', '1'; 'inout', 'rtp_out', 'cint32 &', '', '0', 'async', '' }";
set_param(blk, 'PortAttrs', pa);
```

- **Lines 1-2**: Added an AIE Class Kernel block
- **Lines 4-9**: Specified the C++ class name, the member function, and the source files
- **Line 12**: Imported — the tool read the class definition from `src/kernels.h`
- **Lines 15-20**: Defined:
  - `i1` — input stream (receives continuous data)
  - `o1` — output stream (sends continuous data)  
  - `rtp_out` — RTP parameter (can be changed at runtime)

**Port Attributes Breakdown for Streams:**
```
{ 'Direction', 'Name',     'Type',                   'WindowSize', 'WindowMargin', 'Synchronicity', 'SignalSize' }
  'input',     'i1',       'input_stream_cint32 *',  '',           '0',            '',              ''
  'output',    'o1',       'output_stream_cint32 *', '',           '',             '',              '1'
  'inout',     'rtp_out',  'cint32 &',               '',           '0',            'async',         ''
```
- **Direction**: `'input'`, `'output'`, or `'inout'` (RTP uses inout)
- **Name**: Port name in your C code
- **Type**: C++ type (`input_stream_*` for inputs, `output_stream_*` for outputs)
- **WindowSize**: Empty `''` for streams (no window size)
- **WindowMargin**: Usually `'0'`
- **Synchronicity**: `''` for regular ports, `'async'` for async RTPs
- **SignalSize**: signal size for stream ports; here `''` for the input and `'1'` for the output


## AIE Graph

An **AIE Graph** is a collection of AI Engine kernels connected together in a specific topology (data flow graph). Use this when you have multiple kernels that need to communicate with each other. A graph is defined in an `.h` header file as a C++ class that builds the kernel connections.

### Required Parameters

| Parameter | What It Is | Example |
|-----------|-----------|---------|
| `GraphHeaderFile` | C/C++ header file defining the graph class | `'src/project.h'` |
| `GraphClassName` | Name of the graph class | `'simpleGraph'` |
| `GraphSearchPaths` | Folders where the compiler looks for includes | `"{'./src/kernels', './src'}"` |

### Optional Parameters

| Parameter | What It Does |
|-----------|-------------|
| `GraphSourceFile` | Optional C/C++ source file with implementations |
| `GraphPreProcOptions` | Compiler flags/options |

### Workflow

1. Make sure the model has a **Vitis Model Composer Hub** configured with a Versal AIE device — the AIE Graph parser requires a target device part
2. Set the graph file paths using `set_param()`
3. Call `vmcImportSource()` — reads the graph class and discovers kernels and connections
4. Call `vmcBuildSource()` — **required** — compiles the graph to generate runtime interfaces
5. The block's ports are automatically created based on the graph's input/output ports

**Important:** Always call both `vmcImportSource()` AND `vmcBuildSource()` for graphs.

### Example — Simple AIE Graph

This example imports and builds a graph connecting multiple kernels:

```matlab
model = 'AIE_graph_import';

% Step 0: An AIE Graph build needs a target device, so add a Hub and set a
% Versal AIE device. (Skip if your model already has a configured Hub.)
hub = [model '/Vitis Model Composer Hub'];
add_block('XilinxModelComposer/AI Engine/Tools/Vitis Model Composer Hub', hub);
vmchub_set_param(hub, model, 'SelectHardware', 'xcvc1902-vsva2197-2MP-e-S');

blk = [model '/aie_graph'];
add_block('XilinxModelComposer/AI Engine/User-Defined Functions/AIE Graph', blk);

% Step 1: Point to the graph class definition
set_param(blk, ...
    'GraphHeaderFile',       'src/project.h', ...    % Where the graph is defined
    'GraphClassName',        'simpleGraph', ...       % The C++ class name
    'GraphSearchPaths',      "{'./src/kernels', './src'}", ...
    'GraphPreProcOptions',   '{}');                  % No compiler flags

% Step 2: Import the graph structure (discovers kernels inside)
status = vmcImportSource(blk);
assert(status.success, 'vmcImportSource failed: %s', status.message);

% Step 3: Build the graph (compiles it)
% This generates the actual input/output ports based on the graph topology
status = vmcBuildSource(blk);
assert(status.success, 'vmcBuildSource failed: %s', status.message);
```

- **Lines 1-2**: Added an AIE Graph block
- **Lines 4-8**: Pointed to the graph source files and class name
- **Line 11**: Imported — the tool read `src/project.h` and discovered which kernels are in the graph
- **Line 14-16**: Built — the tool compiled the graph and generated ports

**After vmcBuildSource(), the block's ports are automatically created based on the graph definition.**

### Graph Class Example (What You Put In .h file)

In your `src/project.h`, you would have something like:

```cpp
class simpleGraph {
public:
    aie::kernel k1;      // Kernel 1
    aie::kernel k2;      // Kernel 2
    
    input_plio input;    // External input port
    output_plio output;  // External output port
    
    simpleGraph() {
        // Connect k1 input to external input
        connect(input, k1.in());
        // Connect k1 output to k2 input
        connect(k1.out(), k2.in());
        // Connect k2 output to external output
        connect(k2.out(), output);
    }
};
```

When you import this graph, the block will have two ports:
- An **input** port (connected to `input` plio)
- An **output** port (connected to `output` plio)

## HLS Kernel

An **HLS Kernel** is a C/C++ function that runs on the Programmable Logic (PL) part of the FPGA, not on the AI Engine. HLS stands for High-Level Synthesis — the tool converts C/C++ code to hardware automatically. Use this for algorithms you want to accelerate in PL.

### Required Parameters

| Parameter | What It Is | Example |
|-----------|-----------|---------|
| `KernelHeaderFile` | C/C++ header file with the function declaration | `'kernels/inc/hls_kernels.h'` |
| `KernelFunction` | Name of the function to synthesize | `'pl_func'` |
| `KernelSourceFile` | C/C++ source file with the function code | `'kernels/src/pl_func.cpp'` |
| `KernelSearchPaths` | Folders where the compiler finds includes | `"{'./kernels/inc', './kernels/src'}"` |

### Optional Parameters

| Parameter | What It Does |
|-----------|-------------|
| `PreProcOptions` | Compiler flags (rarely needed for HLS) |

### Workflow

1. Set the file paths using `set_param()`
2. Call `vmcImportSource()` — reads your C/C++ code
3. Set port attributes specifying the types (e.g., `ap_int`, `hls::stream`)
4. Call `vmcBuildSource()` — **required** — runs HLS compiler to generate the hardware
5. The block's ports are automatically created

**Important:** HLS kernels must be built with `vmcBuildSource()` before simulation or hardware implementation.

### Example — HLS Kernel with Integer Ports and Stream Output

This example shows an HLS kernel with:
- An **integer input** (`ap_int< 32 >`)
- A **stream output** (`hls::stream`)

```matlab
blk = 'HLS_kernel_import/hls_kernel';
add_block('XilinxModelComposer/HLS/User-Defined Functions/HLS Kernel', blk);

% --- Step 1: Set general parameters (file paths)
set_param(blk, ...
    'KernelHeaderFile',   'kernels/inc/hls_kernels.h', ...
    'KernelFunction',     'pl_func', ...
    'KernelSourceFile',   'kernels/src/pl_func.cpp', ...
    'KernelSearchPaths',  "{'./kernels/inc', './kernels/src'}", ...
    'PreProcOptions',     '{}');

% --- Step 2: Import to discover the function signature
status = vmcImportSource(blk);
assert(status.success, 'vmcImportSource failed: %s', status.message);

% --- Step 3: Resolve port directions via the nested struct.
% The importer leaves directions it cannot infer (e.g. hls::stream &) as
% '<Select>'; you must resolve them. Port directions (and any template
% values) are dependent, so commit them together with vmcSetBlockInfo.
info = vmcGetBlockInfo(blk);
info.PortDirectionTable(1).Direction = 'Input';    % in1
info.PortDirectionTable(2).Direction = 'Output';   % out1
vmcSetBlockInfo(blk, info);

% --- Step 4: Build (run HLS compiler)
% This generates the hardware from your C/C++ code
status = vmcBuildSource(blk);
assert(status.success, 'vmcBuildSource failed: %s', status.message);
```

- **Lines 1-2**: Added an HLS Kernel block
- **Lines 4-9**: Pointed to the kernel source files
- **Line 12**: Imported — the tool read `hls_kernels.h` to find the function signature
- **Lines 15-18**: Defined ports:
  - `in1` — 32-bit integer input
  - `out1` — 32-bit stream output
- **Line 21-23**: Built — the Vitis HLS tool compiled your C/C++ into hardware (VHDL/Verilog)

### Port Direction Table Explained

```
{ 'name',  'type',                              'direction', 'block_type' }
  'in1',   'ap_int< 32 >',                      'Input',     'Port'
  'out1',  'hls::stream< ap_int< 32 >, 0 > &', 'Output',    'Port'
```

- **name**: Port name in your C function
- **type**: HLS data type
  - `ap_int< N >` — Fixed-width integer (N bits)
  - `ap_uint< N >` — Unsigned integer
  - `hls::stream< TYPE >` — Streaming data
- **direction**: `'Input'` or `'Output'` (must be consistent capitalization)
- **block_type**: Usually `'Port'`

### HLS Template Parameters (Optional, Advanced)

Some HLS kernels may use C++ template parameters to configure synthesis-time behavior. When used, template parameters and port directions are dependent and should be committed together with `vmcSetBlockInfo`:
```matlab
% After vmcImportSource, configure port directions (and any template values)
% via the nested info struct, then commit atomically.
info = vmcGetBlockInfo(blk);
info.PortDirectionTable(1).Direction = 'Input';    % in1
info.PortDirectionTable(2).Direction = 'Output';   % out1
% If the kernel is templated, also set the resolved values, e.g.:
%   info.TemplateParams(1).Value = 'int32';
vmcSetBlockInfo(blk, info);   % atomic commit of dependent parameters
```

Refer to your HLS kernel documentation for supported template parameter formats.
### AIE Kernel with Template Parameters (Advanced)

Some AIE kernels use C++ template parameters for flexible type definitions. Example C++ signature:
```cpp
template< typename T, int N = 4 >
void func_stream(input_stream< T > *in, output_stream< T > *out, output_stream_int32 *out2);
```

To instantiate this kernel with template values, specify them via `FunctionTemplateParams`:
```matlab
blk = 'AIE_template_kernel_import/aie_template_kernel';
add_block('XilinxModelComposer/AI Engine/User-Defined Functions/AIE Kernel', blk);

% Step 1: Set file paths under info.General
info = vmcGetBlockInfo(blk);
info.General.KernelHeaderFile  = 'src/kernels.h';
info.General.KernelFunction    = 'func_stream';
info.General.KernelSourceFile  = 'src/kernels.cpp';
info.General.KernelSearchPaths = '{}';
info.General.PreProcOptions    = '{''-DBUFFER_DEPTH=1024''}';
vmcSetBlockInfo(blk, info);

% Step 2: Import (discovers ports and template parameters from the source)
status = vmcImportSource(blk);
assert(status.success, 'vmcImportSource failed: %s', status.message);

% Step 3: Set template values AND port attributes in ONE atomic commit.
% Port names/types are read from the source signature (in, out, out2); set
% only the editable fields. TemplateParams Name/Type come from the source too,
% so you only supply the resolved Value.
info = vmcGetBlockInfo(blk);
info.TemplateParams(1).Value = 'int32';   % T
info.TemplateParams(2).Value = '4';        % N
info.Ports(2).SignalSize     = '1';        % out  (stream output)
info.Ports(3).SignalSize     = '1';        % out2 (stream output)
vmcSetBlockInfo(blk, info);   % atomic commit of dependent parameters
```

**Format for FunctionTemplateParams:**
```
{ 'paramName', 'paramType', 'paramValue'; 'paramName2', 'paramType2', 'paramValue2' }
  'T',         'typename',  'int32'
  'N',         'int',       '4'
```
- **paramName**: Name of the template parameter (e.g., `T`, `N`)
- **paramType**: Type constraint (`'typename'` for types, `'int'` for integers, etc.)
- **paramValue**: Instantiation value (e.g., `'int32'`, `'4'`)

**Important:** Template parameters and port attributes are dependent, so commit them together with a single `vmcSetBlockInfo` call to ensure atomic, consistent updates. Updating them separately can leave the block in an inconsistent state.
### Common HLS Data Types

| Type | Meaning | Example |
|------|---------|---------|
| `ap_int< 32 >` | 32-bit signed integer | Input/output value |
| `ap_uint< 8 >` | 8-bit unsigned integer | Byte data |
| `hls::stream< ap_int< 32 > >` | Stream of 32-bit integers | Continuous data flow |
| `float` | IEEE 754 floating-point | Decimal values |

---

## Troubleshooting

### Problem: "vmcImportSource failed"

**Possible causes:**
1. **File path is wrong** — The tool can't find your C/C++ files
   - **Fix:** Check that the paths in `KernelHeaderFile`, `KernelSourceFile`, and `KernelSearchPaths` are correct
   - **Tip:** Use relative paths from your current working directory, or absolute paths

2. **C/C++ syntax error in your code** — The compiler found an error
   - **Fix:** Check the error message for which line has the problem. Fix your `.h` or `.cpp` file
   - **Tip:** Compile your code separately with `g++` to find errors faster

3. **Missing include files** — The compiler can't find a header file your code `#include`s
   - **Fix:** Make sure all folders containing includes are listed in `KernelSearchPaths`

**What to do:**
```matlab
status = vmcImportSource(blk);
if ~status.success
    error_msg = status.message;
    fprintf('Error: %s\n', error_msg);
    % Look at error_msg to find the line number and issue
end
```

### Problem: "vmcBuildSource failed"

**Possible causes:**
1. **You forgot to run `vmcImportSource` first** — Import must come before build
   - **Fix:** Always run import before build

2. **Port configuration is wrong** — The ports you defined don't match the C/C++ function
   - **Fix:** Check your port attributes — names, types, and number of ports

3. **HLS compiler errors** — Your C/C++ code has constructs HLS can't handle
   - **Fix:** Make sure your code uses only HLS-compatible features (no dynamic memory, etc.)

### Problem: Ports are not showing up on the block

**Possible causes:**
1. **You didn't run `vmcBuildSource`** — For HLS and Graph blocks, build is required
   - **Fix:** Always call `vmcBuildSource` after import

2. **Port attributes are empty** — You didn't set the PortAttrs parameter
   - **Fix:** Call `set_param(blk, 'PortAttrs', pa)` or `set_param(blk, 'PortDirectionTable', pdt)`

### Problem: "File not found" error

**Possible causes:**
1. **Working directory is wrong** — MATLAB is looking in the wrong folder
   - **Fix:** Use `cd` to change to your project folder, or use absolute paths

2. **Path has spaces** — MATLAB path handling with spaces can be tricky
   - **Fix:** Use double quotes with forward slashes: `"./my folder/file.h"`

3. **Relative path is wrong** — Your relative path doesn't match the folder structure
   - **Fix:** Use `pwd` to see where you are, and `ls` or `dir` to verify file locations

--------------
Copyright (c) 2026 Advanced Micro Devices, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
