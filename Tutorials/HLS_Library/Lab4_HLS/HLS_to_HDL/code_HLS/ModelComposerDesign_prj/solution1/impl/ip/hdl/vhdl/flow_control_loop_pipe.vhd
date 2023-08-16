-- ==============================================================
-- Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.2 (64-bit)
-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- ==============================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flow_control_loop_pipe is
port (
    ap_clk             : in  std_logic;
    ap_rst             : in  std_logic;

    --Block level handshake with outside loop
    ap_start           : in  std_logic;
    ap_ready           : out std_logic;
    ap_done            : out std_logic;
    ap_continue        : in  std_logic;

    --Block level handshake with loop body
    ap_start_int       : out std_logic;
    ap_ready_int       : in  std_logic;
    ap_done_int        : in  std_logic;
    ap_continue_int    : out std_logic;

    --Init live in variables
    --power-on initialization to 1
    ap_loop_init       : out std_logic := '1';

    --Exit signal from loop body
    ap_loop_exit_ready : in  std_logic;
    ap_loop_exit_done  : in  std_logic
);
end entity flow_control_loop_pipe;

architecture behav of flow_control_loop_pipe is
begin 
    ap_start_int    <= ap_start;   
    ap_continue_int <= ap_continue;
    ap_done         <= ap_loop_exit_done;
    ap_ready        <= ap_loop_exit_ready;

    --ap_loop_init is valid for the first II
    --of the first loop run so as to enable
    --the init block ops which are pushed into
    --the first state of the pipeline region
    genLoopInit: process(ap_clk)
    begin
        if rising_edge(ap_clk) then
            if (ap_rst = '1') then
                ap_loop_init <= '1';
            elsif (ap_loop_exit_ready = '1') then
                ap_loop_init <= '1';
            elsif (ap_ready_int = '1') then
                ap_loop_init <= '0';
            end if;
        end if;
    end process genLoopInit;
end architecture;
        
