-- ==============================================================
-- RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.2 (64-bit)
-- Version: 2021.2
-- Copyright (C) Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SobelFilter_XMC_120_160_1_s is
port (
    ap_start : IN STD_LOGIC;
    start_full_n : IN STD_LOGIC;
    start_out : OUT STD_LOGIC;
    start_write : OUT STD_LOGIC;
    Image_in_adapter_out1_dout : IN STD_LOGIC_VECTOR (7 downto 0);
    Image_in_adapter_out1_empty_n : IN STD_LOGIC;
    Image_in_adapter_out1_read : OUT STD_LOGIC;
    SobelFilter_XMC_out1_i_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    SobelFilter_XMC_out1_i_full_n : IN STD_LOGIC;
    SobelFilter_XMC_out1_i_write : OUT STD_LOGIC;
    SobelFilter_XMC_out2_i_din : OUT STD_LOGIC_VECTOR (15 downto 0);
    SobelFilter_XMC_out2_i_full_n : IN STD_LOGIC;
    SobelFilter_XMC_out2_i_write : OUT STD_LOGIC;
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_continue : IN STD_LOGIC );
end;


architecture behav of SobelFilter_XMC_120_160_1_s is 
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_boolean_1 : BOOLEAN := true;

attribute shreg_extract : string;
    signal real_start : STD_LOGIC;
    signal start_once_reg : STD_LOGIC := '0';
    signal internal_ap_ready : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_start : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_done : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_continue : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_idle : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_ready : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_Image_in_adapter_out1_read : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_src_obj_data_din : STD_LOGIC_VECTOR (7 downto 0);
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_src_obj_data_write : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_start_out : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_start_write : STD_LOGIC;
    signal Sobel_0_3_0_2_120_160_1_false_U0_ap_start : STD_LOGIC;
    signal Sobel_0_3_0_2_120_160_1_false_U0_ap_done : STD_LOGIC;
    signal Sobel_0_3_0_2_120_160_1_false_U0_ap_continue : STD_LOGIC;
    signal Sobel_0_3_0_2_120_160_1_false_U0_ap_idle : STD_LOGIC;
    signal Sobel_0_3_0_2_120_160_1_false_U0_ap_ready : STD_LOGIC;
    signal Sobel_0_3_0_2_120_160_1_false_U0_start_out : STD_LOGIC;
    signal Sobel_0_3_0_2_120_160_1_false_U0_start_write : STD_LOGIC;
    signal Sobel_0_3_0_2_120_160_1_false_U0_src_obj_456_read : STD_LOGIC;
    signal Sobel_0_3_0_2_120_160_1_false_U0_dstx_obj_457_din : STD_LOGIC_VECTOR (15 downto 0);
    signal Sobel_0_3_0_2_120_160_1_false_U0_dstx_obj_457_write : STD_LOGIC;
    signal Sobel_0_3_0_2_120_160_1_false_U0_dsty_obj_458_din : STD_LOGIC_VECTOR (15 downto 0);
    signal Sobel_0_3_0_2_120_160_1_false_U0_dsty_obj_458_write : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_start : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_done : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_continue : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_idle : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_ready : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_dstx_obj_data_read : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_dsty_obj_data_read : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out1_i_din : STD_LOGIC_VECTOR (15 downto 0);
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out1_i_write : STD_LOGIC;
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out2_i_din : STD_LOGIC_VECTOR (15 downto 0);
    signal SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out2_i_write : STD_LOGIC;
    signal src_obj_data_full_n : STD_LOGIC;
    signal src_obj_data_dout : STD_LOGIC_VECTOR (7 downto 0);
    signal src_obj_data_empty_n : STD_LOGIC;
    signal dstx_obj_data_full_n : STD_LOGIC;
    signal dstx_obj_data_dout : STD_LOGIC_VECTOR (15 downto 0);
    signal dstx_obj_data_empty_n : STD_LOGIC;
    signal dsty_obj_data_full_n : STD_LOGIC;
    signal dsty_obj_data_dout : STD_LOGIC_VECTOR (15 downto 0);
    signal dsty_obj_data_empty_n : STD_LOGIC;
    signal ap_sync_ready : STD_LOGIC;
    signal start_for_Sobel_0_3_0_2_120_160_1_false_U0_din : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_Sobel_0_3_0_2_120_160_1_false_U0_full_n : STD_LOGIC;
    signal start_for_Sobel_0_3_0_2_120_160_1_false_U0_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_Sobel_0_3_0_2_120_160_1_false_U0_empty_n : STD_LOGIC;
    signal start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_din : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_full_n : STD_LOGIC;
    signal start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_empty_n : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;

    component SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7 IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        start_full_n : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        Image_in_adapter_out1_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        Image_in_adapter_out1_empty_n : IN STD_LOGIC;
        Image_in_adapter_out1_read : OUT STD_LOGIC;
        src_obj_data_din : OUT STD_LOGIC_VECTOR (7 downto 0);
        src_obj_data_full_n : IN STD_LOGIC;
        src_obj_data_write : OUT STD_LOGIC;
        start_out : OUT STD_LOGIC;
        start_write : OUT STD_LOGIC );
    end component;


    component Sobel_0_3_0_2_120_160_1_false_s IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        start_full_n : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        start_out : OUT STD_LOGIC;
        start_write : OUT STD_LOGIC;
        src_obj_456_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        src_obj_456_empty_n : IN STD_LOGIC;
        src_obj_456_read : OUT STD_LOGIC;
        dstx_obj_457_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dstx_obj_457_full_n : IN STD_LOGIC;
        dstx_obj_457_write : OUT STD_LOGIC;
        dsty_obj_458_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        dsty_obj_458_full_n : IN STD_LOGIC;
        dsty_obj_458_write : OUT STD_LOGIC );
    end component;


    component SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8 IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        dstx_obj_data_dout : IN STD_LOGIC_VECTOR (15 downto 0);
        dstx_obj_data_empty_n : IN STD_LOGIC;
        dstx_obj_data_read : OUT STD_LOGIC;
        dsty_obj_data_dout : IN STD_LOGIC_VECTOR (15 downto 0);
        dsty_obj_data_empty_n : IN STD_LOGIC;
        dsty_obj_data_read : OUT STD_LOGIC;
        SobelFilter_XMC_out1_i_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        SobelFilter_XMC_out1_i_full_n : IN STD_LOGIC;
        SobelFilter_XMC_out1_i_write : OUT STD_LOGIC;
        SobelFilter_XMC_out2_i_din : OUT STD_LOGIC_VECTOR (15 downto 0);
        SobelFilter_XMC_out2_i_full_n : IN STD_LOGIC;
        SobelFilter_XMC_out2_i_write : OUT STD_LOGIC );
    end component;


    component fifo_w8_d2_S IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (7 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (7 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component fifo_w16_d2_S IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (15 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (15 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component start_for_Sobel_0_3_0_2_120_160_1_false_U0 IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (0 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (0 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0 IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (0 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (0 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;



begin
    SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0 : component SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_start,
        start_full_n => start_for_Sobel_0_3_0_2_120_160_1_false_U0_full_n,
        ap_done => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_done,
        ap_continue => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_continue,
        ap_idle => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_idle,
        ap_ready => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_ready,
        Image_in_adapter_out1_dout => Image_in_adapter_out1_dout,
        Image_in_adapter_out1_empty_n => Image_in_adapter_out1_empty_n,
        Image_in_adapter_out1_read => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_Image_in_adapter_out1_read,
        src_obj_data_din => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_src_obj_data_din,
        src_obj_data_full_n => src_obj_data_full_n,
        src_obj_data_write => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_src_obj_data_write,
        start_out => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_start_out,
        start_write => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_start_write);

    Sobel_0_3_0_2_120_160_1_false_U0 : component Sobel_0_3_0_2_120_160_1_false_s
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => Sobel_0_3_0_2_120_160_1_false_U0_ap_start,
        start_full_n => start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_full_n,
        ap_done => Sobel_0_3_0_2_120_160_1_false_U0_ap_done,
        ap_continue => Sobel_0_3_0_2_120_160_1_false_U0_ap_continue,
        ap_idle => Sobel_0_3_0_2_120_160_1_false_U0_ap_idle,
        ap_ready => Sobel_0_3_0_2_120_160_1_false_U0_ap_ready,
        start_out => Sobel_0_3_0_2_120_160_1_false_U0_start_out,
        start_write => Sobel_0_3_0_2_120_160_1_false_U0_start_write,
        src_obj_456_dout => src_obj_data_dout,
        src_obj_456_empty_n => src_obj_data_empty_n,
        src_obj_456_read => Sobel_0_3_0_2_120_160_1_false_U0_src_obj_456_read,
        dstx_obj_457_din => Sobel_0_3_0_2_120_160_1_false_U0_dstx_obj_457_din,
        dstx_obj_457_full_n => dstx_obj_data_full_n,
        dstx_obj_457_write => Sobel_0_3_0_2_120_160_1_false_U0_dstx_obj_457_write,
        dsty_obj_458_din => Sobel_0_3_0_2_120_160_1_false_U0_dsty_obj_458_din,
        dsty_obj_458_full_n => dsty_obj_data_full_n,
        dsty_obj_458_write => Sobel_0_3_0_2_120_160_1_false_U0_dsty_obj_458_write);

    SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0 : component SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_start,
        ap_done => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_done,
        ap_continue => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_continue,
        ap_idle => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_idle,
        ap_ready => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_ready,
        dstx_obj_data_dout => dstx_obj_data_dout,
        dstx_obj_data_empty_n => dstx_obj_data_empty_n,
        dstx_obj_data_read => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_dstx_obj_data_read,
        dsty_obj_data_dout => dsty_obj_data_dout,
        dsty_obj_data_empty_n => dsty_obj_data_empty_n,
        dsty_obj_data_read => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_dsty_obj_data_read,
        SobelFilter_XMC_out1_i_din => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out1_i_din,
        SobelFilter_XMC_out1_i_full_n => SobelFilter_XMC_out1_i_full_n,
        SobelFilter_XMC_out1_i_write => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out1_i_write,
        SobelFilter_XMC_out2_i_din => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out2_i_din,
        SobelFilter_XMC_out2_i_full_n => SobelFilter_XMC_out2_i_full_n,
        SobelFilter_XMC_out2_i_write => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out2_i_write);

    src_obj_data_U : component fifo_w8_d2_S
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_src_obj_data_din,
        if_full_n => src_obj_data_full_n,
        if_write => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_src_obj_data_write,
        if_dout => src_obj_data_dout,
        if_empty_n => src_obj_data_empty_n,
        if_read => Sobel_0_3_0_2_120_160_1_false_U0_src_obj_456_read);

    dstx_obj_data_U : component fifo_w16_d2_S
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => Sobel_0_3_0_2_120_160_1_false_U0_dstx_obj_457_din,
        if_full_n => dstx_obj_data_full_n,
        if_write => Sobel_0_3_0_2_120_160_1_false_U0_dstx_obj_457_write,
        if_dout => dstx_obj_data_dout,
        if_empty_n => dstx_obj_data_empty_n,
        if_read => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_dstx_obj_data_read);

    dsty_obj_data_U : component fifo_w16_d2_S
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => Sobel_0_3_0_2_120_160_1_false_U0_dsty_obj_458_din,
        if_full_n => dsty_obj_data_full_n,
        if_write => Sobel_0_3_0_2_120_160_1_false_U0_dsty_obj_458_write,
        if_dout => dsty_obj_data_dout,
        if_empty_n => dsty_obj_data_empty_n,
        if_read => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_dsty_obj_data_read);

    start_for_Sobel_0_3_0_2_120_160_1_false_U0_U : component start_for_Sobel_0_3_0_2_120_160_1_false_U0
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => start_for_Sobel_0_3_0_2_120_160_1_false_U0_din,
        if_full_n => start_for_Sobel_0_3_0_2_120_160_1_false_U0_full_n,
        if_write => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_start_write,
        if_dout => start_for_Sobel_0_3_0_2_120_160_1_false_U0_dout,
        if_empty_n => start_for_Sobel_0_3_0_2_120_160_1_false_U0_empty_n,
        if_read => Sobel_0_3_0_2_120_160_1_false_U0_ap_ready);

    start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_U : component start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_din,
        if_full_n => start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_full_n,
        if_write => Sobel_0_3_0_2_120_160_1_false_U0_start_write,
        if_dout => start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_dout,
        if_empty_n => start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_empty_n,
        if_read => SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_ready);





    start_once_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                start_once_reg <= ap_const_logic_0;
            else
                if (((real_start = ap_const_logic_1) and (internal_ap_ready = ap_const_logic_0))) then 
                    start_once_reg <= ap_const_logic_1;
                elsif ((internal_ap_ready = ap_const_logic_1)) then 
                    start_once_reg <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;

    Image_in_adapter_out1_read <= SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_Image_in_adapter_out1_read;
    SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_continue <= ap_continue;
    SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_start <= start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_empty_n;
    SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_continue <= ap_const_logic_1;
    SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_start <= real_start;
    SobelFilter_XMC_out1_i_din <= SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out1_i_din;
    SobelFilter_XMC_out1_i_write <= SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out1_i_write;
    SobelFilter_XMC_out2_i_din <= SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out2_i_din;
    SobelFilter_XMC_out2_i_write <= SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_SobelFilter_XMC_out2_i_write;
    Sobel_0_3_0_2_120_160_1_false_U0_ap_continue <= ap_const_logic_1;
    Sobel_0_3_0_2_120_160_1_false_U0_ap_start <= start_for_Sobel_0_3_0_2_120_160_1_false_U0_empty_n;
    ap_done <= SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_done;
    ap_idle <= (Sobel_0_3_0_2_120_160_1_false_U0_ap_idle and SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_idle and SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_ap_idle);
    ap_ready <= SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_ready;
    ap_sync_ready <= SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_94_1_proc7_U0_ap_ready;
    internal_ap_ready <= ap_sync_ready;

    real_start_assign_proc : process(ap_start, start_full_n, start_once_reg)
    begin
        if (((start_once_reg = ap_const_logic_0) and (start_full_n = ap_const_logic_0))) then 
            real_start <= ap_const_logic_0;
        else 
            real_start <= ap_start;
        end if; 
    end process;

    start_for_SobelFilter_XMC_120_160_1_Loop_VITIS_LOOP_104_3_proc8_U0_din <= (0=>ap_const_logic_1, others=>'-');
    start_for_Sobel_0_3_0_2_120_160_1_false_U0_din <= (0=>ap_const_logic_1, others=>'-');
    start_out <= real_start;

    start_write_assign_proc : process(real_start, start_once_reg)
    begin
        if (((start_once_reg = ap_const_logic_0) and (real_start = ap_const_logic_1))) then 
            start_write <= ap_const_logic_1;
        else 
            start_write <= ap_const_logic_0;
        end if; 
    end process;

end behav;
