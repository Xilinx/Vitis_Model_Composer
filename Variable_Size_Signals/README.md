# Variabel Size Signals
## Introduction
A Simulink variable-size signal is a signal whose size (the number of elements in a dimension), in addition to its values, can change during a model simulation. Look at the video below that showcases a variable size signal.

![](VariableSizeSignalIntro.gif)

## Knowledge nuggets

:bulb: Use the Simulink *Width* block to see the number of elements in the variable size signal.

:bulb: All AI Engine blocks can consume variable size signals and also produce variable size signals.

:bulb: Note how a varrable signal looks different than a fixed size signal in Simulink.

## Viweing variable size signals

You can view variable size signals with a display block or a scope block. Note if the variable size signal is not full, the scope showes empty spaces.

![](VariableSizeSignalScope.gif)

### Knowledge nuggets

:bulb: You can view variable size signals using a display block, a scope block, or wrtie them into the MATLAB workspace. 

## Converting variable size signals to fixed size signals

At times you need to convert vairble size signals to fixed size signals. This is necessary if you need to use a block that does not support variable size signals. In such cases you can use the *ToFixed Size* block. However, this block will introduce zeros for the missing elements if the variable size signal is not full. Usage of this block is mostly for when the variable size signal is always full. You can check that during the simulaiton by monitoring the status port of the block.

![](VariableSizeSignalToFixedSize.gif)

## Write a variable size signal to MATLAB workspace

You can wrtie a variable size signal to MATLAB workspace using *Variable Size Signal to Workspace* block. From there, you can post process the data. Note that the data will be concatenated and unlike the "To Fixed Size" block, no zeros are introduced.

![](toWorkspace.PNG)

