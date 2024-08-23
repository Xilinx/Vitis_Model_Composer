# ==============================================================
# Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.1 (64-bit)
# Tool Version Limit: 2024.05
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
# 
# ==============================================================
source -notrace "/proj/xbuilds/SWIP/2024.1_0522_2023/installs/lin64/Vitis_HLS/2024.1/common/scripts/ipxhls.tcl"
set ip_dir "/group/xcoswmktg2/robg/git/vmc_examples/Vitis_Model_Composer/Tutorials/HDL_Library/Lab2/C_code/hls_project/hls_component/MedianFilter/hls/impl/ip"
set data_file "/group/xcoswmktg2/robg/git/vmc_examples/Vitis_Model_Composer/Tutorials/HDL_Library/Lab2/C_code/hls_project/hls_component/MedianFilter/hls/hls_data.json"
set ip_types "vitis sysgen"
if { [catch {::ipx::utils::package_hls_ip $ip_dir $data_file $ip_types } res] } {
  puts "Caught error:\n$::errorInfo"
  error $res
}
