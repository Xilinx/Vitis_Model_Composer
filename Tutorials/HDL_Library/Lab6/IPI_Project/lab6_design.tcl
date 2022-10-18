#
# Script to generate the Vivado project for SysGen Tutorial Lab6
#
# run with :
# vivado -mode tcl -source run_vivado.tcl
#

# Set project parameters
set my_part xc7z020clg484-1
set my_board_part xilinx.com:zc702:part0:1.4
set projdir ./project_1
set projname project_1
set repo_dir ./ip


create_project -force $projname $projdir -part $my_part
set_property board_part $my_board_part [current_project]

set_property ip_repo_paths $repo_dir [current_fileset]

update_ip_catalog -rebuild

source ./Lab6_IPI.tcl
# the script sets up $design_name

generate_target all [get_files  $projdir/$projname.srcs/sources_1/bd/$design_name/$design_name.bd]

make_wrapper -files [get_files $projdir/$projname.srcs/sources_1/bd/$design_name/$design_name.bd] -top
add_files -norecurse $projdir/$projname.srcs/sources_1/bd/$design_name/hdl/${design_name}_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

#exit
