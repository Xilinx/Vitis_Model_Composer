############################################################
## This file is generated automatically by Vitis HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2020 Xilinx, Inc. All Rights Reserved.
############################################################
open_project polar_clip
set_top polar_clip
add_files src/polar_clip.cpp
open_solution "solution1" -flow_target vivado
set_part {xcvu11p-flga2577-1-e}
create_clock -period 10 -name default
#source "./polar_clip/solution1/directives.tcl"
#csim_design
csynth_design
#cosim_design
export_design -format ip_catalog
