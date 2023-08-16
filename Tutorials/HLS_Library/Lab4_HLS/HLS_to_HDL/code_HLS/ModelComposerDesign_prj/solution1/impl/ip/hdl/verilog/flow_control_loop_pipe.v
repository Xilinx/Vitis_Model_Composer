// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.2 (64-bit)
// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// ==============================================================

`timescale 1 ns / 1 ps

module flow_control_loop_pipe(
        ap_clk,
        ap_rst,
        ap_start,
        ap_ready,
        ap_done,
        ap_continue,
        ap_start_int,
        ap_ready_int,
        ap_done_int,
        ap_continue_int,
        ap_loop_init,
        ap_loop_exit_ready,
        ap_loop_exit_done
);

input   ap_clk;
input   ap_rst;

//Block level handshake with outside loop
input   ap_start;
output  ap_ready;
output  ap_done;
input   ap_continue;

//Block level handshake with loop body
output  ap_start_int;
input   ap_ready_int;
input   ap_done_int;
output  ap_continue_int;

//Init live in variables
output   ap_loop_init;
reg ap_loop_init;

//Exit signal from loop body
input   ap_loop_exit_ready;
input   ap_loop_exit_done;

// power-on initialization
initial begin
#0 ap_loop_init = 1'b1;
end

assign ap_start_int = ap_start;

assign ap_continue_int = ap_continue;

assign ap_done = ap_loop_exit_done;

assign ap_ready = ap_loop_exit_ready;

//ap_loop_init is valid for the first II
//of the first loop run so as to enable
//the init block ops which are pushed into
//the first state of the pipeline region
always @ (posedge ap_clk)
begin
    if (ap_rst == 1'b1) begin
        ap_loop_init <= 1'b1;
    end else if(ap_loop_exit_ready == 1'b1) begin
        ap_loop_init <= 1'b1;
    end else if(ap_ready_int == 1'b1) begin
        ap_loop_init <= 1'b0;
    end
end

endmodule
        
