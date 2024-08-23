-- ==============================================================
-- Generated by Vitis HLS v2024.1
-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- ==============================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MedianFilter is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    row1 : IN STD_LOGIC_VECTOR (7 downto 0);
    row2 : IN STD_LOGIC_VECTOR (7 downto 0);
    row3 : IN STD_LOGIC_VECTOR (7 downto 0);
    V : OUT STD_LOGIC_VECTOR (7 downto 0);
    V_ap_vld : OUT STD_LOGIC );
end;


architecture behav of MedianFilter is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "MedianFilter_MedianFilter,hls_ip_2024_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7k325t-fbg676-3,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=pipeline,HLS_SYN_CLOCK=6.756000,HLS_SYN_LAT=2,HLS_SYN_TPT=1,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=115,HLS_SYN_LUT=527,HLS_VERSION=2024_1}";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_pp0_stage0 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_boolean_0 : BOOLEAN := false;

    signal ap_CS_fsm : STD_LOGIC_VECTOR (0 downto 0) := "1";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_pp0_stage0 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_pp0_stage0 : signal is "none";
    signal ap_enable_reg_pp0_iter0 : STD_LOGIC;
    signal ap_enable_reg_pp0_iter1 : STD_LOGIC := '0';
    signal ap_enable_reg_pp0_iter2 : STD_LOGIC := '0';
    signal ap_idle_pp0 : STD_LOGIC;
    signal ap_block_pp0_stage0_subdone : BOOLEAN;
    signal MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_4 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_5 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_2 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_3 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_1 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    signal select_ln12_fu_267_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln12_reg_468 : STD_LOGIC_VECTOR (7 downto 0);
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal sortBuffer_15_fu_275_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal sortBuffer_15_reg_474 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln13_1_fu_347_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln13_1_reg_480 : STD_LOGIC_VECTOR (7 downto 0);
    signal sortBuffer_16_fu_361_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal sortBuffer_16_reg_486 : STD_LOGIC_VECTOR (7 downto 0);
    signal sortBuffer_14_fu_369_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal sortBuffer_14_reg_492 : STD_LOGIC_VECTOR (7 downto 0);
    signal sortBuffer_19_fu_383_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal sortBuffer_19_reg_498 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln15_1_fu_429_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln15_1_reg_504 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln15_3_fu_450_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln15_3_reg_510 : STD_LOGIC_VECTOR (7 downto 0);
    signal ap_block_pp0_stage0 : BOOLEAN;
    signal ap_block_pp0_stage0_01001 : BOOLEAN;
    signal icmp_ln10_fu_129_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal icmp_ln10_1_fu_151_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal icmp_ln10_2_fu_173_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal sortBuffer_6_fu_143_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln11_fu_195_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal select_ln10_3_fu_165_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln11_1_fu_217_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal sortBuffer_7_fu_187_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln11_2_fu_239_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal select_ln11_1_fu_209_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln10_fu_135_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln12_fu_261_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal sortBuffer_9_fu_231_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal sortBuffer_8_fu_157_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln12_1_fu_283_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal select_ln11_5_fu_253_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln10_4_fu_179_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln12_2_fu_305_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal sortBuffer_11_fu_201_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal sortBuffer_10_fu_223_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln13_fu_327_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal select_ln12_3_fu_297_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln12_5_fu_319_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln13_1_fu_341_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal sortBuffer_13_fu_289_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal sortBuffer_12_fu_311_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln13_2_fu_355_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal select_ln13_fu_333_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln11_4_fu_245_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln14_fu_377_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal icmp_ln14_1_fu_391_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal icmp_ln14_2_fu_401_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal sortBuffer_17_fu_395_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln15_fu_411_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal select_ln15_fu_416_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal select_ln14_2_fu_405_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln15_1_fu_423_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal sortBuffer_18_fu_437_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal icmp_ln15_2_fu_445_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal icmp_ln16_fu_457_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_idle_pp0_0to1 : STD_LOGIC;
    signal ap_reset_idle_pp0 : STD_LOGIC;
    signal ap_enable_pp0 : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;


begin




    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_pp0_stage0;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter1_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter1 <= ap_const_logic_0;
            else
                if (((ap_const_boolean_0 = ap_block_pp0_stage0_subdone) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
                    ap_enable_reg_pp0_iter1 <= ap_start;
                end if; 
            end if;
        end if;
    end process;


    ap_enable_reg_pp0_iter2_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_enable_reg_pp0_iter2 <= ap_const_logic_0;
            else
                if ((ap_const_boolean_0 = ap_block_pp0_stage0_subdone)) then 
                    ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
                end if; 
            end if;
        end if;
    end process;

    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi <= MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_1;
                MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_1 <= row3;
                MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_2 <= MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_3;
                MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_3 <= row2;
                MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_4 <= MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_5;
                MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_5 <= row1;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then
                select_ln12_reg_468 <= select_ln12_fu_267_p3;
                select_ln13_1_reg_480 <= select_ln13_1_fu_347_p3;
                select_ln15_1_reg_504 <= select_ln15_1_fu_429_p3;
                select_ln15_3_reg_510 <= select_ln15_3_fu_450_p3;
                sortBuffer_14_reg_492 <= sortBuffer_14_fu_369_p3;
                sortBuffer_15_reg_474 <= sortBuffer_15_fu_275_p3;
                sortBuffer_16_reg_486 <= sortBuffer_16_fu_361_p3;
                sortBuffer_19_reg_498 <= sortBuffer_19_fu_383_p3;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_CS_fsm, ap_block_pp0_stage0_subdone, ap_reset_idle_pp0)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_pp0_stage0 => 
                ap_NS_fsm <= ap_ST_fsm_pp0_stage0;
            when others =>  
                ap_NS_fsm <= "X";
        end case;
    end process;
    V <= 
        select_ln15_1_reg_504 when (icmp_ln16_fu_457_p2(0) = '1') else 
        select_ln15_3_reg_510;

    V_ap_vld_assign_proc : process(ap_enable_reg_pp0_iter2, ap_block_pp0_stage0_11001)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_enable_reg_pp0_iter2 = ap_const_logic_1))) then 
            V_ap_vld <= ap_const_logic_1;
        else 
            V_ap_vld <= ap_const_logic_0;
        end if; 
    end process;

    ap_CS_fsm_pp0_stage0 <= ap_CS_fsm(0);
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_pp0_stage0_01001 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_pp0_stage0_11001 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_pp0_stage0_subdone <= not((ap_const_boolean_1 = ap_const_boolean_1));

    ap_done_assign_proc : process(ap_enable_reg_pp0_iter2, ap_block_pp0_stage0_subdone)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_subdone) and (ap_enable_reg_pp0_iter2 = ap_const_logic_1))) then 
            ap_done <= ap_const_logic_1;
        else 
            ap_done <= ap_const_logic_0;
        end if; 
    end process;

    ap_enable_pp0 <= (ap_idle_pp0 xor ap_const_logic_1);
    ap_enable_reg_pp0_iter0 <= ap_start;

    ap_idle_assign_proc : process(ap_start, ap_CS_fsm_pp0_stage0, ap_idle_pp0)
    begin
        if (((ap_start = ap_const_logic_0) and (ap_idle_pp0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;


    ap_idle_pp0_assign_proc : process(ap_enable_reg_pp0_iter0, ap_enable_reg_pp0_iter1, ap_enable_reg_pp0_iter2)
    begin
        if (((ap_enable_reg_pp0_iter2 = ap_const_logic_0) and (ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_0))) then 
            ap_idle_pp0 <= ap_const_logic_1;
        else 
            ap_idle_pp0 <= ap_const_logic_0;
        end if; 
    end process;


    ap_idle_pp0_0to1_assign_proc : process(ap_enable_reg_pp0_iter0, ap_enable_reg_pp0_iter1)
    begin
        if (((ap_enable_reg_pp0_iter1 = ap_const_logic_0) and (ap_enable_reg_pp0_iter0 = ap_const_logic_0))) then 
            ap_idle_pp0_0to1 <= ap_const_logic_1;
        else 
            ap_idle_pp0_0to1 <= ap_const_logic_0;
        end if; 
    end process;


    ap_ready_assign_proc : process(ap_CS_fsm_pp0_stage0, ap_enable_reg_pp0_iter0, ap_block_pp0_stage0_subdone)
    begin
        if (((ap_const_boolean_0 = ap_block_pp0_stage0_subdone) and (ap_enable_reg_pp0_iter0 = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_pp0_stage0))) then 
            ap_ready <= ap_const_logic_1;
        else 
            ap_ready <= ap_const_logic_0;
        end if; 
    end process;


    ap_reset_idle_pp0_assign_proc : process(ap_start, ap_idle_pp0_0to1)
    begin
        if (((ap_start = ap_const_logic_0) and (ap_idle_pp0_0to1 = ap_const_logic_1))) then 
            ap_reset_idle_pp0 <= ap_const_logic_1;
        else 
            ap_reset_idle_pp0 <= ap_const_logic_0;
        end if; 
    end process;

    icmp_ln10_1_fu_151_p2 <= "1" when (unsigned(MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_3) > unsigned(MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_2)) else "0";
    icmp_ln10_2_fu_173_p2 <= "1" when (unsigned(MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_1) > unsigned(MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi)) else "0";
    icmp_ln10_fu_129_p2 <= "1" when (unsigned(MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_5) > unsigned(MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_4)) else "0";
    icmp_ln11_1_fu_217_p2 <= "1" when (unsigned(select_ln10_3_fu_165_p3) < unsigned(row2)) else "0";
    icmp_ln11_2_fu_239_p2 <= "1" when (unsigned(sortBuffer_7_fu_187_p3) < unsigned(row3)) else "0";
    icmp_ln11_fu_195_p2 <= "1" when (unsigned(sortBuffer_6_fu_143_p3) < unsigned(row1)) else "0";
    icmp_ln12_1_fu_283_p2 <= "1" when (unsigned(sortBuffer_9_fu_231_p3) > unsigned(sortBuffer_8_fu_157_p3)) else "0";
    icmp_ln12_2_fu_305_p2 <= "1" when (unsigned(select_ln11_5_fu_253_p3) > unsigned(select_ln10_4_fu_179_p3)) else "0";
    icmp_ln12_fu_261_p2 <= "1" when (unsigned(select_ln11_1_fu_209_p3) > unsigned(select_ln10_fu_135_p3)) else "0";
    icmp_ln13_1_fu_341_p2 <= "1" when (unsigned(select_ln12_3_fu_297_p3) > unsigned(select_ln12_5_fu_319_p3)) else "0";
    icmp_ln13_2_fu_355_p2 <= "1" when (unsigned(sortBuffer_13_fu_289_p3) > unsigned(sortBuffer_12_fu_311_p3)) else "0";
    icmp_ln13_fu_327_p2 <= "1" when (unsigned(sortBuffer_11_fu_201_p3) > unsigned(sortBuffer_10_fu_223_p3)) else "0";
    icmp_ln14_1_fu_391_p2 <= "1" when (unsigned(sortBuffer_15_reg_474) > unsigned(sortBuffer_14_reg_492)) else "0";
    icmp_ln14_2_fu_401_p2 <= "1" when (unsigned(select_ln12_reg_468) > unsigned(select_ln13_1_reg_480)) else "0";
    icmp_ln14_fu_377_p2 <= "1" when (unsigned(select_ln13_fu_333_p3) > unsigned(select_ln11_4_fu_245_p3)) else "0";
    icmp_ln15_1_fu_423_p2 <= "1" when (unsigned(select_ln15_fu_416_p3) > unsigned(select_ln14_2_fu_405_p3)) else "0";
    icmp_ln15_2_fu_445_p2 <= "1" when (unsigned(sortBuffer_19_reg_498) > unsigned(sortBuffer_18_fu_437_p3)) else "0";
    icmp_ln15_fu_411_p2 <= "1" when (unsigned(sortBuffer_17_fu_395_p3) > unsigned(sortBuffer_16_reg_486)) else "0";
    icmp_ln16_fu_457_p2 <= "1" when (unsigned(select_ln15_3_reg_510) > unsigned(select_ln15_1_reg_504)) else "0";
    select_ln10_3_fu_165_p3 <= 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_2 when (icmp_ln10_1_fu_151_p2(0) = '1') else 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_3;
    select_ln10_4_fu_179_p3 <= 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_1 when (icmp_ln10_2_fu_173_p2(0) = '1') else 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi;
    select_ln10_fu_135_p3 <= 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_5 when (icmp_ln10_fu_129_p2(0) = '1') else 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_4;
    select_ln11_1_fu_209_p3 <= 
        row1 when (icmp_ln11_fu_195_p2(0) = '1') else 
        sortBuffer_6_fu_143_p3;
    select_ln11_4_fu_245_p3 <= 
        sortBuffer_7_fu_187_p3 when (icmp_ln11_2_fu_239_p2(0) = '1') else 
        row3;
    select_ln11_5_fu_253_p3 <= 
        row3 when (icmp_ln11_2_fu_239_p2(0) = '1') else 
        sortBuffer_7_fu_187_p3;
    select_ln12_3_fu_297_p3 <= 
        sortBuffer_9_fu_231_p3 when (icmp_ln12_1_fu_283_p2(0) = '1') else 
        sortBuffer_8_fu_157_p3;
    select_ln12_5_fu_319_p3 <= 
        select_ln11_5_fu_253_p3 when (icmp_ln12_2_fu_305_p2(0) = '1') else 
        select_ln10_4_fu_179_p3;
    select_ln12_fu_267_p3 <= 
        select_ln11_1_fu_209_p3 when (icmp_ln12_fu_261_p2(0) = '1') else 
        select_ln10_fu_135_p3;
    select_ln13_1_fu_347_p3 <= 
        select_ln12_5_fu_319_p3 when (icmp_ln13_1_fu_341_p2(0) = '1') else 
        select_ln12_3_fu_297_p3;
    select_ln13_fu_333_p3 <= 
        sortBuffer_11_fu_201_p3 when (icmp_ln13_fu_327_p2(0) = '1') else 
        sortBuffer_10_fu_223_p3;
    select_ln14_2_fu_405_p3 <= 
        select_ln13_1_reg_480 when (icmp_ln14_2_fu_401_p2(0) = '1') else 
        select_ln12_reg_468;
    select_ln15_1_fu_429_p3 <= 
        select_ln15_fu_416_p3 when (icmp_ln15_1_fu_423_p2(0) = '1') else 
        select_ln14_2_fu_405_p3;
    select_ln15_3_fu_450_p3 <= 
        sortBuffer_19_reg_498 when (icmp_ln15_2_fu_445_p2(0) = '1') else 
        sortBuffer_18_fu_437_p3;
    select_ln15_fu_416_p3 <= 
        sortBuffer_16_reg_486 when (icmp_ln15_fu_411_p2(0) = '1') else 
        sortBuffer_17_fu_395_p3;
    sortBuffer_10_fu_223_p3 <= 
        select_ln10_3_fu_165_p3 when (icmp_ln11_1_fu_217_p2(0) = '1') else 
        row2;
    sortBuffer_11_fu_201_p3 <= 
        sortBuffer_6_fu_143_p3 when (icmp_ln11_fu_195_p2(0) = '1') else 
        row1;
    sortBuffer_12_fu_311_p3 <= 
        select_ln10_4_fu_179_p3 when (icmp_ln12_2_fu_305_p2(0) = '1') else 
        select_ln11_5_fu_253_p3;
    sortBuffer_13_fu_289_p3 <= 
        sortBuffer_8_fu_157_p3 when (icmp_ln12_1_fu_283_p2(0) = '1') else 
        sortBuffer_9_fu_231_p3;
    sortBuffer_14_fu_369_p3 <= 
        sortBuffer_12_fu_311_p3 when (icmp_ln13_2_fu_355_p2(0) = '1') else 
        sortBuffer_13_fu_289_p3;
    sortBuffer_15_fu_275_p3 <= 
        select_ln10_fu_135_p3 when (icmp_ln12_fu_261_p2(0) = '1') else 
        select_ln11_1_fu_209_p3;
    sortBuffer_16_fu_361_p3 <= 
        sortBuffer_13_fu_289_p3 when (icmp_ln13_2_fu_355_p2(0) = '1') else 
        sortBuffer_12_fu_311_p3;
    sortBuffer_17_fu_395_p3 <= 
        sortBuffer_15_reg_474 when (icmp_ln14_1_fu_391_p2(0) = '1') else 
        sortBuffer_14_reg_492;
    sortBuffer_18_fu_437_p3 <= 
        select_ln14_2_fu_405_p3 when (icmp_ln15_1_fu_423_p2(0) = '1') else 
        select_ln15_fu_416_p3;
    sortBuffer_19_fu_383_p3 <= 
        select_ln13_fu_333_p3 when (icmp_ln14_fu_377_p2(0) = '1') else 
        select_ln11_4_fu_245_p3;
    sortBuffer_6_fu_143_p3 <= 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_4 when (icmp_ln10_fu_129_p2(0) = '1') else 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_5;
    sortBuffer_7_fu_187_p3 <= 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi when (icmp_ln10_2_fu_173_p2(0) = '1') else 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_1;
    sortBuffer_8_fu_157_p3 <= 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_3 when (icmp_ln10_1_fu_151_p2(0) = '1') else 
        MedianFilter_unsigned_char_unsigned_char_unsigned_char_unsigned_char_pixelWi_2;
    sortBuffer_9_fu_231_p3 <= 
        row2 when (icmp_ln11_1_fu_217_p2(0) = '1') else 
        select_ln10_3_fu_165_p3;
end behav;
