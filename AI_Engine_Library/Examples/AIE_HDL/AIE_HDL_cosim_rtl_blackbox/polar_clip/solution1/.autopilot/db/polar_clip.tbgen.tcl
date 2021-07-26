set moduleName polar_clip
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_none
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set C_modelName {polar_clip}
set C_modelType { void 0 }
set C_modelArgList {
	{ in_sample_V_data_V int 32 regular {axi_s 0 volatile  { in_sample Data } }  }
	{ in_sample_V_keep_V int 4 regular {axi_s 0 volatile  { in_sample Keep } }  }
	{ in_sample_V_strb_V int 4 regular {axi_s 0 volatile  { in_sample Strb } }  }
	{ in_sample_V_last_V int 1 regular {axi_s 0 volatile  { in_sample Last } }  }
	{ out_sample_V_data_V int 32 regular {axi_s 1 volatile  { out_sample Data } }  }
	{ out_sample_V_keep_V int 4 regular {axi_s 1 volatile  { out_sample Keep } }  }
	{ out_sample_V_strb_V int 4 regular {axi_s 1 volatile  { out_sample Strb } }  }
	{ out_sample_V_last_V int 1 regular {axi_s 1 volatile  { out_sample Last } }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "in_sample_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "in_sample.V.data.V","cData": "int","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 1,"step" : 1}]}]}]} , 
 	{ "Name" : "in_sample_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY", "bitSlice":[{"low":0,"up":3,"cElement": [{"cName": "in_sample.V.keep.V","cData": "int4","bit_use": { "low": 0,"up": 3},"cArray": [{"low" : 0,"up" : 1,"step" : 1}]}]}]} , 
 	{ "Name" : "in_sample_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY", "bitSlice":[{"low":0,"up":3,"cElement": [{"cName": "in_sample.V.strb.V","cData": "int4","bit_use": { "low": 0,"up": 3},"cArray": [{"low" : 0,"up" : 1,"step" : 1}]}]}]} , 
 	{ "Name" : "in_sample_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "in_sample.V.last.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 1,"step" : 1}]}]}]} , 
 	{ "Name" : "out_sample_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "out_sample.V.data.V","cData": "int","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 1,"step" : 1}]}]}]} , 
 	{ "Name" : "out_sample_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":3,"cElement": [{"cName": "out_sample.V.keep.V","cData": "int4","bit_use": { "low": 0,"up": 3},"cArray": [{"low" : 0,"up" : 1,"step" : 1}]}]}]} , 
 	{ "Name" : "out_sample_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":3,"cElement": [{"cName": "out_sample.V.strb.V","cData": "int4","bit_use": { "low": 0,"up": 3},"cArray": [{"low" : 0,"up" : 1,"step" : 1}]}]}]} , 
 	{ "Name" : "out_sample_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "out_sample.V.last.V","cData": "int1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 1,"step" : 1}]}]}]} ]}
# RTL Port declarations: 
set portNum 14
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ in_sample_TDATA sc_in sc_lv 32 signal 0 } 
	{ in_sample_TVALID sc_in sc_logic 1 invld 3 } 
	{ in_sample_TREADY sc_out sc_logic 1 inacc 3 } 
	{ in_sample_TKEEP sc_in sc_lv 4 signal 1 } 
	{ in_sample_TSTRB sc_in sc_lv 4 signal 2 } 
	{ in_sample_TLAST sc_in sc_lv 1 signal 3 } 
	{ out_sample_TDATA sc_out sc_lv 32 signal 4 } 
	{ out_sample_TVALID sc_out sc_logic 1 outvld 7 } 
	{ out_sample_TREADY sc_in sc_logic 1 outacc 7 } 
	{ out_sample_TKEEP sc_out sc_lv 4 signal 5 } 
	{ out_sample_TSTRB sc_out sc_lv 4 signal 6 } 
	{ out_sample_TLAST sc_out sc_lv 1 signal 7 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "in_sample_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_sample_V_data_V", "role": "default" }} , 
 	{ "name": "in_sample_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_sample_V_last_V", "role": "default" }} , 
 	{ "name": "in_sample_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_sample_V_last_V", "role": "default" }} , 
 	{ "name": "in_sample_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_sample_V_keep_V", "role": "default" }} , 
 	{ "name": "in_sample_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_sample_V_strb_V", "role": "default" }} , 
 	{ "name": "in_sample_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_sample_V_last_V", "role": "default" }} , 
 	{ "name": "out_sample_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_sample_V_data_V", "role": "default" }} , 
 	{ "name": "out_sample_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_sample_V_last_V", "role": "default" }} , 
 	{ "name": "out_sample_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_sample_V_last_V", "role": "default" }} , 
 	{ "name": "out_sample_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_sample_V_keep_V", "role": "default" }} , 
 	{ "name": "out_sample_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_sample_V_strb_V", "role": "default" }} , 
 	{ "name": "out_sample_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_sample_V_last_V", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15"],
		"CDFG" : "polar_clip",
		"Protocol" : "ap_ctrl_none",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "18", "EstimateLatencyMax" : "18",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "in_sample_V_data_V", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_sample_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "in_sample_V_keep_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "in_sample_V_strb_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "in_sample_V_last_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "out_sample_V_data_V", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "out_sample_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "out_sample_V_keep_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "out_sample_V_strb_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "out_sample_V_last_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "rotation_sin_lut", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "rotation_cos_lut", "Type" : "Memory", "Direction" : "I"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.rotation_sin_lut_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.rotation_cos_lut_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_16s_16s_32_4_1_U1", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mac_muladd_16s_16s_32s_32_4_1_U2", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_10ns_25s_25_4_1_U3", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_16s_16s_16_4_1_U4", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mul_mul_16s_16s_16_4_1_U5", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_in_sample_V_data_V_U", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_in_sample_V_keep_V_U", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_in_sample_V_strb_V_U", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_in_sample_V_last_V_U", "Parent" : "0"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_out_sample_V_data_V_U", "Parent" : "0"},
	{"ID" : "13", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_out_sample_V_keep_V_U", "Parent" : "0"},
	{"ID" : "14", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_out_sample_V_strb_V_U", "Parent" : "0"},
	{"ID" : "15", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.regslice_both_out_sample_V_last_V_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	polar_clip {
		in_sample_V_data_V {Type I LastRead 0 FirstWrite -1}
		in_sample_V_keep_V {Type I LastRead 0 FirstWrite -1}
		in_sample_V_strb_V {Type I LastRead 0 FirstWrite -1}
		in_sample_V_last_V {Type I LastRead 0 FirstWrite -1}
		out_sample_V_data_V {Type O LastRead -1 FirstWrite 12}
		out_sample_V_keep_V {Type O LastRead -1 FirstWrite 12}
		out_sample_V_strb_V {Type O LastRead -1 FirstWrite 12}
		out_sample_V_last_V {Type O LastRead -1 FirstWrite 12}
		rotation_sin_lut {Type I LastRead -1 FirstWrite -1}
		rotation_cos_lut {Type I LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "18", "Max" : "18"}
	, {"Name" : "Interval", "Min" : "19", "Max" : "19"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_sample_V_data_V { axis {  { in_sample_TDATA in_data 0 32 } } }
	in_sample_V_keep_V { axis {  { in_sample_TKEEP in_data 0 4 } } }
	in_sample_V_strb_V { axis {  { in_sample_TSTRB in_data 0 4 } } }
	in_sample_V_last_V { axis {  { in_sample_TVALID in_vld 0 1 }  { in_sample_TREADY in_acc 1 1 }  { in_sample_TLAST in_data 0 1 } } }
	out_sample_V_data_V { axis {  { out_sample_TDATA out_data 1 32 } } }
	out_sample_V_keep_V { axis {  { out_sample_TKEEP out_data 1 4 } } }
	out_sample_V_strb_V { axis {  { out_sample_TSTRB out_data 1 4 } } }
	out_sample_V_last_V { axis {  { out_sample_TVALID out_vld 1 1 }  { out_sample_TREADY out_acc 0 1 }  { out_sample_TLAST out_data 1 1 } } }
}

set busDeadlockParameterList { 
}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
