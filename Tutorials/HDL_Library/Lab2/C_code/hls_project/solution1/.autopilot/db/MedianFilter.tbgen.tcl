set moduleName MedianFilter
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type function
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set C_modelName {MedianFilter}
set C_modelType { void 0 }
set C_modelArgList {
	{ row1 uint 8 regular  }
	{ row2 uint 8 regular  }
	{ row3 uint 8 regular  }
	{ V int 8 regular {pointer 1}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "row1", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "row2", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "row3", "interface" : "wire", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "V", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 11
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ row1 sc_in sc_lv 8 signal 0 } 
	{ row2 sc_in sc_lv 8 signal 1 } 
	{ row3 sc_in sc_lv 8 signal 2 } 
	{ V sc_out sc_lv 8 signal 3 } 
	{ V_ap_vld sc_out sc_logic 1 outvld 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "row1", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "row1", "role": "default" }} , 
 	{ "name": "row2", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "row2", "role": "default" }} , 
 	{ "name": "row3", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "row3", "role": "default" }} , 
 	{ "name": "V", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "V", "role": "default" }} , 
 	{ "name": "V_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "V", "role": "ap_vld" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "",
		"CDFG" : "MedianFilter",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "Aligned", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "1", "EstimateLatencyMin" : "1", "EstimateLatencyMax" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"Port" : [
			{"Name" : "row1", "Type" : "None", "Direction" : "I"},
			{"Name" : "row2", "Type" : "None", "Direction" : "I"},
			{"Name" : "row3", "Type" : "None", "Direction" : "I"},
			{"Name" : "V", "Type" : "Vld", "Direction" : "O"},
			{"Name" : "pixelWindowBuffer_1", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pixelWindowBuffer_0", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pixelWindowBuffer_4", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pixelWindowBuffer_3", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pixelWindowBuffer_7", "Type" : "OVld", "Direction" : "IO"},
			{"Name" : "pixelWindowBuffer_6", "Type" : "OVld", "Direction" : "IO"}]}]}


set ArgLastReadFirstWriteLatency {
	MedianFilter {
		row1 {Type I LastRead 0 FirstWrite -1}
		row2 {Type I LastRead 0 FirstWrite -1}
		row3 {Type I LastRead 0 FirstWrite -1}
		V {Type O LastRead -1 FirstWrite 1}
		pixelWindowBuffer_1 {Type IO LastRead -1 FirstWrite -1}
		pixelWindowBuffer_0 {Type IO LastRead -1 FirstWrite -1}
		pixelWindowBuffer_4 {Type IO LastRead -1 FirstWrite -1}
		pixelWindowBuffer_3 {Type IO LastRead -1 FirstWrite -1}
		pixelWindowBuffer_7 {Type IO LastRead -1 FirstWrite -1}
		pixelWindowBuffer_6 {Type IO LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1", "Max" : "1"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "1"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	row1 { ap_none {  { row1 in_data 0 8 } } }
	row2 { ap_none {  { row2 in_data 0 8 } } }
	row3 { ap_none {  { row3 in_data 0 8 } } }
	V { ap_vld {  { V out_data 1 8 }  { V_ap_vld out_vld 1 1 } } }
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
