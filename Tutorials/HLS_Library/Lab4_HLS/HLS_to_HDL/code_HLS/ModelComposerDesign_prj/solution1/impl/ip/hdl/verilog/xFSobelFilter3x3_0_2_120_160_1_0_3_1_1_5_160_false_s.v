// ==============================================================
// RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.2 (64-bit)
// Version: 2021.2
// Copyright (C) Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_s (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        src_obj_456_dout,
        src_obj_456_empty_n,
        src_obj_456_read,
        dstx_obj_457_din,
        dstx_obj_457_full_n,
        dstx_obj_457_write,
        dsty_obj_458_din,
        dsty_obj_458_full_n,
        dsty_obj_458_write
);

parameter    ap_ST_fsm_state1 = 7'd1;
parameter    ap_ST_fsm_state2 = 7'd2;
parameter    ap_ST_fsm_state3 = 7'd4;
parameter    ap_ST_fsm_state4 = 7'd8;
parameter    ap_ST_fsm_state5 = 7'd16;
parameter    ap_ST_fsm_state6 = 7'd32;
parameter    ap_ST_fsm_state7 = 7'd64;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [7:0] src_obj_456_dout;
input   src_obj_456_empty_n;
output   src_obj_456_read;
output  [15:0] dstx_obj_457_din;
input   dstx_obj_457_full_n;
output   dstx_obj_457_write;
output  [15:0] dsty_obj_458_din;
input   dsty_obj_458_full_n;
output   dsty_obj_458_write;

reg ap_done;
reg ap_idle;
reg ap_ready;
reg src_obj_456_read;
reg[15:0] dstx_obj_457_din;
reg dstx_obj_457_write;
reg[15:0] dsty_obj_458_din;
reg dsty_obj_458_write;

(* fsm_encoding = "none" *) reg   [6:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    dstx_obj_457_blk_n;
wire    ap_CS_fsm_state7;
reg    dsty_obj_458_blk_n;
reg   [1:0] bottom_V_reg_467;
wire    ap_CS_fsm_state4;
wire   [0:0] icmp_ln353_fu_205_p2;
reg   [1:0] mid_V_reg_472;
reg   [1:0] tp_V_reg_477;
wire   [0:0] cmp_i_i517_i_fu_313_p2;
reg   [0:0] cmp_i_i517_i_reg_482;
wire   [1:0] empty_24_fu_320_p1;
reg   [1:0] empty_24_reg_487;
wire   [12:0] row_ind_V_1_fu_325_p2;
reg   [12:0] row_ind_V_1_reg_492;
wire   [10:0] tmp_xFGradientX3x3_0_3_s_fu_167_ap_return;
reg   [10:0] tmp_reg_498;
wire    ap_CS_fsm_state6;
wire   [10:0] tmp_2_xFGradientY3x3_0_3_s_fu_180_ap_return;
reg   [10:0] tmp_2_reg_503;
reg    buf_V_ce0;
wire   [7:0] buf_V_q0;
reg   [7:0] buf_V_address1;
reg    buf_V_ce1;
reg    buf_V_we1;
reg   [7:0] buf_V_d1;
reg    buf_V_1_ce0;
wire   [7:0] buf_V_1_q0;
reg   [7:0] buf_V_1_address1;
reg    buf_V_1_ce1;
reg    buf_V_1_we1;
reg   [7:0] buf_V_1_d1;
wire   [7:0] buf_V_2_q0;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_start;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_done;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_idle;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_ready;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_src_obj_456_read;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_address1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_ce1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_we1;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_d1;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_address1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_ce1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_we1;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_d1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_start;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_done;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_idle;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_ready;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_obj_456_read;
wire   [15:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dstx_obj_457_din;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dstx_obj_457_write;
wire   [15:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dsty_obj_458_din;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dsty_obj_458_write;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_address0;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_ce0;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_address1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_ce1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_we1;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_d1;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_address0;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_ce0;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_address1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_ce1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_we1;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_d1;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_address0;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_ce0;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_address1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_ce1;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_we1;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_d1;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_buf3_V_1_out;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_buf3_V_1_out_ap_vld;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_2_out;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_2_out_ap_vld;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_1_out;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_1_out_ap_vld;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_buf1_V_1_out;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_buf1_V_1_out_ap_vld;
wire   [7:0] grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_out;
wire    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_out_ap_vld;
wire    tmp_xFGradientX3x3_0_3_s_fu_167_ap_ready;
wire    tmp_2_xFGradientY3x3_0_3_s_fu_180_ap_ready;
reg    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_start_reg;
wire    ap_CS_fsm_state2;
reg    grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_start_reg;
wire    ap_CS_fsm_state5;
reg   [12:0] row_ind_V_fu_68;
wire   [12:0] row_ind_V_2_fu_347_p3;
wire   [12:0] row_ind_V_load_1_load_fu_211_p1;
reg   [6:0] row_V_fu_72;
wire   [6:0] row_V_3_fu_331_p2;
reg   [1:0] bottom_fu_76;
wire   [1:0] bottom_1_fu_259_p3;
reg   [1:0] ap_sig_allocacmp_bottom_V;
reg   [1:0] mid_fu_80;
wire   [1:0] mid_1_fu_267_p3;
reg   [1:0] ap_sig_allocacmp_mid_V;
reg   [1:0] tp_fu_84;
wire   [1:0] tp_1_fu_275_p3;
reg   [1:0] ap_sig_allocacmp_tp_V;
wire  signed [15:0] sext_ln413_fu_381_p1;
reg    ap_block_state7;
wire  signed [15:0] sext_ln413_1_fu_385_p1;
wire   [0:0] icmp_ln1064_fu_253_p2;
wire   [0:0] icmp_ln1064_1_fu_342_p2;
reg   [6:0] ap_NS_fsm;
reg    ap_ST_fsm_state1_blk;
reg    ap_ST_fsm_state2_blk;
wire    ap_ST_fsm_state3_blk;
wire    ap_ST_fsm_state4_blk;
reg    ap_ST_fsm_state5_blk;
wire    ap_ST_fsm_state6_blk;
reg    ap_ST_fsm_state7_blk;
wire    ap_ce_reg;

// power-on initialization
initial begin
#0 ap_CS_fsm = 7'd1;
#0 grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_start_reg = 1'b0;
#0 grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_start_reg = 1'b0;
end

xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_s_buf_V_RAM_S2P_BRAM_1R1W #(
    .DataWidth( 8 ),
    .AddressRange( 160 ),
    .AddressWidth( 8 ))
buf_V_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .address0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_address0),
    .ce0(buf_V_ce0),
    .q0(buf_V_q0),
    .address1(buf_V_address1),
    .ce1(buf_V_ce1),
    .we1(buf_V_we1),
    .d1(buf_V_d1)
);

xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_s_buf_V_RAM_S2P_BRAM_1R1W #(
    .DataWidth( 8 ),
    .AddressRange( 160 ),
    .AddressWidth( 8 ))
buf_V_1_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .address0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_address0),
    .ce0(buf_V_1_ce0),
    .q0(buf_V_1_q0),
    .address1(buf_V_1_address1),
    .ce1(buf_V_1_ce1),
    .we1(buf_V_1_we1),
    .d1(buf_V_1_d1)
);

xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_s_buf_V_RAM_S2P_BRAM_1R1W #(
    .DataWidth( 8 ),
    .AddressRange( 160 ),
    .AddressWidth( 8 ))
buf_V_2_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .address0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_address0),
    .ce0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_ce0),
    .q0(buf_V_2_q0),
    .address1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_address1),
    .ce1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_ce1),
    .we1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_we1),
    .d1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_d1)
);

xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_start),
    .ap_done(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_done),
    .ap_idle(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_idle),
    .ap_ready(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_ready),
    .src_obj_456_dout(src_obj_456_dout),
    .src_obj_456_empty_n(src_obj_456_empty_n),
    .src_obj_456_read(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_src_obj_456_read),
    .buf_V_address1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_address1),
    .buf_V_ce1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_ce1),
    .buf_V_we1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_we1),
    .buf_V_d1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_d1),
    .buf_V_1_address1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_address1),
    .buf_V_1_ce1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_ce1),
    .buf_V_1_we1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_we1),
    .buf_V_1_d1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_d1)
);

xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_start),
    .ap_done(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_done),
    .ap_idle(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_idle),
    .ap_ready(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_ready),
    .src_obj_456_dout(src_obj_456_dout),
    .src_obj_456_empty_n(src_obj_456_empty_n),
    .src_obj_456_read(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_obj_456_read),
    .dstx_obj_457_din(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dstx_obj_457_din),
    .dstx_obj_457_full_n(dstx_obj_457_full_n),
    .dstx_obj_457_write(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dstx_obj_457_write),
    .dsty_obj_458_din(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dsty_obj_458_din),
    .dsty_obj_458_full_n(dsty_obj_458_full_n),
    .dsty_obj_458_write(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dsty_obj_458_write),
    .buf_V_address0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_address0),
    .buf_V_ce0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_ce0),
    .buf_V_q0(buf_V_q0),
    .buf_V_address1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_address1),
    .buf_V_ce1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_ce1),
    .buf_V_we1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_we1),
    .buf_V_d1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_d1),
    .buf_V_1_address0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_address0),
    .buf_V_1_ce0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_ce0),
    .buf_V_1_q0(buf_V_1_q0),
    .buf_V_1_address1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_address1),
    .buf_V_1_ce1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_ce1),
    .buf_V_1_we1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_we1),
    .buf_V_1_d1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_d1),
    .buf_V_2_address0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_address0),
    .buf_V_2_ce0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_ce0),
    .buf_V_2_q0(buf_V_2_q0),
    .buf_V_2_address1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_address1),
    .buf_V_2_ce1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_ce1),
    .buf_V_2_we1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_we1),
    .buf_V_2_d1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_2_d1),
    .tp_V(tp_V_reg_477),
    .mid_V(mid_V_reg_472),
    .bottom_V(bottom_V_reg_467),
    .row_ind_V_cast(empty_24_reg_487),
    .cmp_i_i517_i(cmp_i_i517_i_reg_482),
    .src_buf3_V_1_out(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_buf3_V_1_out),
    .src_buf3_V_1_out_ap_vld(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_buf3_V_1_out_ap_vld),
    .p_Val2_2_out(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_2_out),
    .p_Val2_2_out_ap_vld(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_2_out_ap_vld),
    .p_Val2_1_out(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_1_out),
    .p_Val2_1_out_ap_vld(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_1_out_ap_vld),
    .src_buf1_V_1_out(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_buf1_V_1_out),
    .src_buf1_V_1_out_ap_vld(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_buf1_V_1_out_ap_vld),
    .p_Val2_out(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_out),
    .p_Val2_out_ap_vld(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_out_ap_vld)
);

xFGradientX3x3_0_3_s tmp_xFGradientX3x3_0_3_s_fu_167(
    .ap_ready(tmp_xFGradientX3x3_0_3_s_fu_167_ap_ready),
    .t0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_out),
    .t2(8'd0),
    .m0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_1_out),
    .m2(8'd0),
    .b0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_2_out),
    .b2(8'd0),
    .ap_return(tmp_xFGradientX3x3_0_3_s_fu_167_ap_return)
);

xFGradientY3x3_0_3_s tmp_2_xFGradientY3x3_0_3_s_fu_180(
    .ap_ready(tmp_2_xFGradientY3x3_0_3_s_fu_180_ap_ready),
    .t0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_out),
    .t1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_buf1_V_1_out),
    .t2(8'd0),
    .b0(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_p_Val2_2_out),
    .b1(grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_buf3_V_1_out),
    .b2(8'd0),
    .ap_return(tmp_2_xFGradientY3x3_0_3_s_fu_180_ap_return)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_start_reg <= 1'b0;
    end else begin
        if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
            grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_start_reg <= 1'b1;
        end else if ((grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_ready == 1'b1)) begin
            grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_start_reg <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_start_reg <= 1'b0;
    end else begin
        if (((icmp_ln353_fu_205_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
            grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_start_reg <= 1'b1;
        end else if ((grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_ready == 1'b1)) begin
            grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_start_reg <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln353_fu_205_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        if ((~(row_ind_V_load_1_load_fu_211_p1 == 13'd2) & ~(row_ind_V_load_1_load_fu_211_p1 == 13'd0))) begin
            bottom_fu_76 <= bottom_1_fu_259_p3;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd2)) begin
            bottom_fu_76 <= 2'd2;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd0)) begin
            bottom_fu_76 <= 2'd0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln353_fu_205_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        if ((~(row_ind_V_load_1_load_fu_211_p1 == 13'd2) & ~(row_ind_V_load_1_load_fu_211_p1 == 13'd0))) begin
            mid_fu_80 <= mid_1_fu_267_p3;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd2)) begin
            mid_fu_80 <= 2'd1;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd0)) begin
            mid_fu_80 <= 2'd2;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
        row_V_fu_72 <= 7'd1;
    end else if (((icmp_ln353_fu_205_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        row_V_fu_72 <= row_V_3_fu_331_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
        row_ind_V_fu_68 <= 13'd2;
    end else if (((1'b1 == ap_CS_fsm_state5) & (grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_done == 1'b1))) begin
        row_ind_V_fu_68 <= row_ind_V_2_fu_347_p3;
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln353_fu_205_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        if ((~(row_ind_V_load_1_load_fu_211_p1 == 13'd2) & ~(row_ind_V_load_1_load_fu_211_p1 == 13'd0))) begin
            tp_fu_84 <= tp_1_fu_275_p3;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd2)) begin
            tp_fu_84 <= 2'd0;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd0)) begin
            tp_fu_84 <= 2'd1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((icmp_ln353_fu_205_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        bottom_V_reg_467 <= ap_sig_allocacmp_bottom_V;
        cmp_i_i517_i_reg_482 <= cmp_i_i517_i_fu_313_p2;
        empty_24_reg_487 <= empty_24_fu_320_p1;
        mid_V_reg_472 <= ap_sig_allocacmp_mid_V;
        row_ind_V_1_reg_492 <= row_ind_V_1_fu_325_p2;
        tp_V_reg_477 <= ap_sig_allocacmp_tp_V;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state6)) begin
        tmp_2_reg_503 <= tmp_2_xFGradientY3x3_0_3_s_fu_180_ap_return;
        tmp_reg_498 <= tmp_xFGradientX3x3_0_3_s_fu_167_ap_return;
    end
end

always @ (*) begin
    if ((ap_start == 1'b0)) begin
        ap_ST_fsm_state1_blk = 1'b1;
    end else begin
        ap_ST_fsm_state1_blk = 1'b0;
    end
end

always @ (*) begin
    if ((grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_done == 1'b0)) begin
        ap_ST_fsm_state2_blk = 1'b1;
    end else begin
        ap_ST_fsm_state2_blk = 1'b0;
    end
end

assign ap_ST_fsm_state3_blk = 1'b0;

assign ap_ST_fsm_state4_blk = 1'b0;

always @ (*) begin
    if ((grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_done == 1'b0)) begin
        ap_ST_fsm_state5_blk = 1'b1;
    end else begin
        ap_ST_fsm_state5_blk = 1'b0;
    end
end

assign ap_ST_fsm_state6_blk = 1'b0;

always @ (*) begin
    if (((dsty_obj_458_full_n == 1'b0) | (dstx_obj_457_full_n == 1'b0))) begin
        ap_ST_fsm_state7_blk = 1'b1;
    end else begin
        ap_ST_fsm_state7_blk = 1'b0;
    end
end

always @ (*) begin
    if ((((icmp_ln353_fu_205_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state4)) | ((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b0)))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b0))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln353_fu_205_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state4))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if (((icmp_ln353_fu_205_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        if ((~(row_ind_V_load_1_load_fu_211_p1 == 13'd2) & ~(row_ind_V_load_1_load_fu_211_p1 == 13'd0))) begin
            ap_sig_allocacmp_bottom_V = bottom_1_fu_259_p3;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd2)) begin
            ap_sig_allocacmp_bottom_V = 2'd2;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd0)) begin
            ap_sig_allocacmp_bottom_V = 2'd0;
        end else begin
            ap_sig_allocacmp_bottom_V = bottom_fu_76;
        end
    end else begin
        ap_sig_allocacmp_bottom_V = bottom_fu_76;
    end
end

always @ (*) begin
    if (((icmp_ln353_fu_205_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        if ((~(row_ind_V_load_1_load_fu_211_p1 == 13'd2) & ~(row_ind_V_load_1_load_fu_211_p1 == 13'd0))) begin
            ap_sig_allocacmp_mid_V = mid_1_fu_267_p3;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd2)) begin
            ap_sig_allocacmp_mid_V = 2'd1;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd0)) begin
            ap_sig_allocacmp_mid_V = 2'd2;
        end else begin
            ap_sig_allocacmp_mid_V = mid_fu_80;
        end
    end else begin
        ap_sig_allocacmp_mid_V = mid_fu_80;
    end
end

always @ (*) begin
    if (((icmp_ln353_fu_205_p2 == 1'd0) & (1'b1 == ap_CS_fsm_state4))) begin
        if ((~(row_ind_V_load_1_load_fu_211_p1 == 13'd2) & ~(row_ind_V_load_1_load_fu_211_p1 == 13'd0))) begin
            ap_sig_allocacmp_tp_V = tp_1_fu_275_p3;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd2)) begin
            ap_sig_allocacmp_tp_V = 2'd0;
        end else if ((row_ind_V_load_1_load_fu_211_p1 == 13'd0)) begin
            ap_sig_allocacmp_tp_V = 2'd1;
        end else begin
            ap_sig_allocacmp_tp_V = tp_fu_84;
        end
    end else begin
        ap_sig_allocacmp_tp_V = tp_fu_84;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        buf_V_1_address1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_address1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        buf_V_1_address1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_address1;
    end else begin
        buf_V_1_address1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        buf_V_1_ce0 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_ce0;
    end else begin
        buf_V_1_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        buf_V_1_ce1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_ce1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        buf_V_1_ce1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_ce1;
    end else begin
        buf_V_1_ce1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        buf_V_1_d1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_d1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        buf_V_1_d1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_d1;
    end else begin
        buf_V_1_d1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        buf_V_1_we1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_1_we1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        buf_V_1_we1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_1_we1;
    end else begin
        buf_V_1_we1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        buf_V_address1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_address1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        buf_V_address1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_address1;
    end else begin
        buf_V_address1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        buf_V_ce0 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_ce0;
    end else begin
        buf_V_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        buf_V_ce1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_ce1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        buf_V_ce1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_ce1;
    end else begin
        buf_V_ce1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        buf_V_d1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_d1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        buf_V_d1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_d1;
    end else begin
        buf_V_d1 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        buf_V_we1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_buf_V_we1;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        buf_V_we1 = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_buf_V_we1;
    end else begin
        buf_V_we1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state7)) begin
        dstx_obj_457_blk_n = dstx_obj_457_full_n;
    end else begin
        dstx_obj_457_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((dsty_obj_458_full_n == 1'b0) | (dstx_obj_457_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state7))) begin
        dstx_obj_457_din = sext_ln413_fu_381_p1;
    end else if ((1'b1 == ap_CS_fsm_state5)) begin
        dstx_obj_457_din = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dstx_obj_457_din;
    end else begin
        dstx_obj_457_din = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dstx_obj_457_din;
    end
end

always @ (*) begin
    if ((~((dsty_obj_458_full_n == 1'b0) | (dstx_obj_457_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state7))) begin
        dstx_obj_457_write = 1'b1;
    end else if ((1'b1 == ap_CS_fsm_state5)) begin
        dstx_obj_457_write = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dstx_obj_457_write;
    end else begin
        dstx_obj_457_write = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state7)) begin
        dsty_obj_458_blk_n = dsty_obj_458_full_n;
    end else begin
        dsty_obj_458_blk_n = 1'b1;
    end
end

always @ (*) begin
    if ((~((dsty_obj_458_full_n == 1'b0) | (dstx_obj_457_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state7))) begin
        dsty_obj_458_din = sext_ln413_1_fu_385_p1;
    end else if ((1'b1 == ap_CS_fsm_state5)) begin
        dsty_obj_458_din = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dsty_obj_458_din;
    end else begin
        dsty_obj_458_din = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dsty_obj_458_din;
    end
end

always @ (*) begin
    if ((~((dsty_obj_458_full_n == 1'b0) | (dstx_obj_457_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state7))) begin
        dsty_obj_458_write = 1'b1;
    end else if ((1'b1 == ap_CS_fsm_state5)) begin
        dsty_obj_458_write = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_dsty_obj_458_write;
    end else begin
        dsty_obj_458_write = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        src_obj_456_read = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_src_obj_456_read;
    end else if ((1'b1 == ap_CS_fsm_state2)) begin
        src_obj_456_read = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_src_obj_456_read;
    end else begin
        src_obj_456_read = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if (((1'b1 == ap_CS_fsm_state1) & (ap_start == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if (((1'b1 == ap_CS_fsm_state2) & (grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_done == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state4;
        end
        ap_ST_fsm_state4 : begin
            if (((icmp_ln353_fu_205_p2 == 1'd1) & (1'b1 == ap_CS_fsm_state4))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end
        end
        ap_ST_fsm_state5 : begin
            if (((1'b1 == ap_CS_fsm_state5) & (grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_done == 1'b1))) begin
                ap_NS_fsm = ap_ST_fsm_state6;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end
        end
        ap_ST_fsm_state6 : begin
            ap_NS_fsm = ap_ST_fsm_state7;
        end
        ap_ST_fsm_state7 : begin
            if ((~((dsty_obj_458_full_n == 1'b0) | (dstx_obj_457_full_n == 1'b0)) & (1'b1 == ap_CS_fsm_state7))) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state7;
            end
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state4 = ap_CS_fsm[32'd3];

assign ap_CS_fsm_state5 = ap_CS_fsm[32'd4];

assign ap_CS_fsm_state6 = ap_CS_fsm[32'd5];

assign ap_CS_fsm_state7 = ap_CS_fsm[32'd6];

always @ (*) begin
    ap_block_state7 = ((dsty_obj_458_full_n == 1'b0) | (dstx_obj_457_full_n == 1'b0));
end

assign bottom_1_fu_259_p3 = ((icmp_ln1064_fu_253_p2[0:0] == 1'b1) ? 2'd1 : bottom_fu_76);

assign cmp_i_i517_i_fu_313_p2 = ((row_V_fu_72 < 7'd120) ? 1'b1 : 1'b0);

assign empty_24_fu_320_p1 = row_ind_V_fu_68[1:0];

assign grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_start = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Clear_Row_Loop_fu_134_ap_start_reg;

assign grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_start = grp_xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_Pipeline_Col_Loop_fu_144_ap_start_reg;

assign icmp_ln1064_1_fu_342_p2 = ((row_ind_V_1_reg_492 == 13'd3) ? 1'b1 : 1'b0);

assign icmp_ln1064_fu_253_p2 = ((row_ind_V_fu_68 == 13'd1) ? 1'b1 : 1'b0);

assign icmp_ln353_fu_205_p2 = ((row_V_fu_72 == 7'd121) ? 1'b1 : 1'b0);

assign mid_1_fu_267_p3 = ((icmp_ln1064_fu_253_p2[0:0] == 1'b1) ? 2'd0 : mid_fu_80);

assign row_V_3_fu_331_p2 = (row_V_fu_72 + 7'd1);

assign row_ind_V_1_fu_325_p2 = (row_ind_V_fu_68 + 13'd1);

assign row_ind_V_2_fu_347_p3 = ((icmp_ln1064_1_fu_342_p2[0:0] == 1'b1) ? 13'd0 : row_ind_V_1_reg_492);

assign row_ind_V_load_1_load_fu_211_p1 = row_ind_V_fu_68;

assign sext_ln413_1_fu_385_p1 = $signed(tmp_2_reg_503);

assign sext_ln413_fu_381_p1 = $signed(tmp_reg_498);

assign tp_1_fu_275_p3 = ((icmp_ln1064_fu_253_p2[0:0] == 1'b1) ? 2'd2 : tp_fu_84);

endmodule //xFSobelFilter3x3_0_2_120_160_1_0_3_1_1_5_160_false_s
