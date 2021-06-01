
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regslice_both is
GENERIC (DataWidth : INTEGER := 32);
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;

    data_in : IN STD_LOGIC_VECTOR (DataWidth-1 downto 0);
    vld_in : IN STD_LOGIC;
    ack_in : OUT STD_LOGIC;
    data_out : OUT STD_LOGIC_VECTOR (DataWidth-1 downto 0);
    vld_out : OUT STD_LOGIC;
    ack_out : IN STD_LOGIC;
    apdone_blk : OUT STD_LOGIC );
end;

architecture behav of regslice_both is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant ap_const_lv2_1 : STD_LOGIC_VECTOR (1 downto 0) := "01";
    constant ap_const_lv2_2 : STD_LOGIC_VECTOR (1 downto 0) := "10";
    constant ap_const_lv2_3 : STD_LOGIC_VECTOR (1 downto 0) := "11";

    signal B_V_data_1_ack_in : STD_LOGIC;
    signal B_V_data_1_ack_out : STD_LOGIC;
    signal B_V_data_1_state : STD_LOGIC_VECTOR (1 downto 0) := "00";
    signal B_V_data_1_data_in : STD_LOGIC_VECTOR (DataWidth-1 downto 0);
    signal B_V_data_1_data_out : STD_LOGIC_VECTOR (DataWidth-1 downto 0);
    signal B_V_data_1_vld_in : STD_LOGIC;
    signal B_V_data_1_vld_out : STD_LOGIC;
    signal B_V_data_1_payload_A : STD_LOGIC_VECTOR (DataWidth-1 downto 0);
    signal B_V_data_1_payload_B : STD_LOGIC_VECTOR (DataWidth-1 downto 0);
    signal B_V_data_1_sel_rd : STD_LOGIC := '0';
    signal B_V_data_1_sel_wr : STD_LOGIC := '0';
    signal B_V_data_1_sel : STD_LOGIC;
    signal B_V_data_1_load_A : STD_LOGIC;
    signal B_V_data_1_load_B : STD_LOGIC;
    signal B_V_data_1_state_cmp_full : STD_LOGIC;

begin

    B_V_data_1_sel_rd_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                B_V_data_1_sel_rd <= ap_const_logic_0;
            else
                if (((ap_const_logic_1 = B_V_data_1_vld_out) and (ap_const_logic_1 = B_V_data_1_ack_out))) then 
                    B_V_data_1_sel_rd <= not(B_V_data_1_sel_rd);
                end if; 
            end if;
        end if;
    end process;

    B_V_data_1_sel_wr_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                B_V_data_1_sel_wr <= ap_const_logic_0;
            else
                if (((ap_const_logic_1 = B_V_data_1_vld_in) and (ap_const_logic_1 = B_V_data_1_ack_in))) then 
                    B_V_data_1_sel_wr <= not(B_V_data_1_sel_wr);
                end if; 
            end if;
        end if;
    end process;

    B_V_data_1_state_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                B_V_data_1_state <= ap_const_lv2_0;
            else
                if ((((ap_const_lv2_3 = B_V_data_1_state) and (ap_const_logic_0 = B_V_data_1_vld_in) and (ap_const_logic_1 = B_V_data_1_ack_out)) or ((ap_const_lv2_2 = B_V_data_1_state) and (ap_const_logic_0 = B_V_data_1_vld_in)))) then 
                    B_V_data_1_state <= ap_const_lv2_2;
                elsif ((((ap_const_lv2_1 = B_V_data_1_state) and (ap_const_logic_0 = B_V_data_1_ack_out)) or ((ap_const_lv2_3 = B_V_data_1_state) and (ap_const_logic_0 = B_V_data_1_ack_out) and (ap_const_logic_1 = B_V_data_1_vld_in)))) then 
                    B_V_data_1_state <= ap_const_lv2_1;
                elsif ((((ap_const_lv2_1 = B_V_data_1_state) and (ap_const_logic_1 = B_V_data_1_ack_out)) or (not(((ap_const_logic_0 = B_V_data_1_ack_out) and (ap_const_logic_1 = B_V_data_1_vld_in))) and not(((ap_const_logic_0 = B_V_data_1_vld_in) and (ap_const_logic_1 = B_V_data_1_ack_out))) and (ap_const_lv2_3 = B_V_data_1_state)) or ((ap_const_lv2_2 = B_V_data_1_state) and (ap_const_logic_1 = B_V_data_1_vld_in)))) then 
                    B_V_data_1_state <= ap_const_lv2_3;
                else 
                    B_V_data_1_state <= ap_const_lv2_2;
                end if; 
            end if;
        end if;
    end process;


    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = B_V_data_1_load_A)) then
                B_V_data_1_payload_A <= B_V_data_1_data_in;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = B_V_data_1_load_B)) then
                B_V_data_1_payload_B <= B_V_data_1_data_in;
            end if;
        end if;
    end process;

    B_V_data_1_data_out_assign_proc : process(B_V_data_1_payload_A, B_V_data_1_payload_B, B_V_data_1_sel)
    begin
        if ((ap_const_logic_1 = B_V_data_1_sel)) then 
            B_V_data_1_data_out <= B_V_data_1_payload_B;
        else 
            B_V_data_1_data_out <= B_V_data_1_payload_A;
        end if; 
    end process;

    B_V_data_1_ack_in <= B_V_data_1_state(1);

    B_V_data_1_load_A <= (not(B_V_data_1_sel_wr) and B_V_data_1_state_cmp_full);
    B_V_data_1_load_B <= (B_V_data_1_state_cmp_full and B_V_data_1_sel_wr);
    B_V_data_1_sel <= B_V_data_1_sel_rd;
    B_V_data_1_state_cmp_full <= '0' when (B_V_data_1_state = ap_const_lv2_1) else '1';

    B_V_data_1_vld_out <= B_V_data_1_state(0);

    B_V_data_1_vld_in <= vld_in;
    B_V_data_1_data_in <= data_in;
    ack_in <= B_V_data_1_ack_in;
    
    vld_out <= B_V_data_1_vld_out;
    data_out <= B_V_data_1_data_out;
    B_V_data_1_ack_out <= ack_out;

    apdone_blk_assign_proc : process(B_V_data_1_state, ack_out)
    begin
        if(((B_V_data_1_state = ap_const_lv2_3) and (ack_out = ap_const_logic_0)) or (B_V_data_1_state = ap_const_lv2_1)) then
            apdone_blk <= ap_const_logic_1;
        else
            apdone_blk <= ap_const_logic_0;   
        end if; 
    end process;

end behav;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regslice_forward is
GENERIC (DataWidth : INTEGER := 32);
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;

    data_in : IN STD_LOGIC_VECTOR (DataWidth-1 downto 0);
    vld_in : IN STD_LOGIC;
    ack_in : OUT STD_LOGIC;
    data_out : OUT STD_LOGIC_VECTOR (DataWidth-1 downto 0);
    vld_out : OUT STD_LOGIC;
    ack_out : IN STD_LOGIC;
    apdone_blk : OUT STD_LOGIC );
end;

architecture behav of regslice_forward is 
    constant W : INTEGER := DataWidth+1;
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant ap_const_lv2_1 : STD_LOGIC_VECTOR (1 downto 0) := "01";
    constant ap_const_lv2_2 : STD_LOGIC_VECTOR (1 downto 0) := "10";
    constant ap_const_lv2_3 : STD_LOGIC_VECTOR (1 downto 0) := "11";
    signal idata : STD_LOGIC_VECTOR (W-1 downto 0);
    signal istop : STD_LOGIC;
    signal odata : STD_LOGIC_VECTOR (W-1 downto 0);
    signal ostop : STD_LOGIC;
    
    signal vld_out_int : STD_LOGIC;

    component regslice_obuf IS
    generic (
        W : INTEGER );
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        cdata : IN STD_LOGIC_VECTOR (W-1 downto 0);
        cstop : OUT STD_LOGIC;
        odata : OUT STD_LOGIC_VECTOR (W-1 downto 0);
        ostop : IN STD_LOGIC );
    end component;

begin

    regslice_obuf_inst : component regslice_obuf 
    generic map (
        W => W)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        cdata => idata,
        cstop => istop,
        odata => odata,
        ostop => ostop);

    idata <= (vld_in & data_in);
    ack_in <= not(istop);

    vld_out_int <= odata(W-1);
    vld_out <= vld_out_int;
    data_out <= odata(W-2 downto 0);
    ostop <= not(ack_out);

    apdone_blk_assign_proc : process(ap_rst, ack_out, vld_out_int)
    begin
        if((ap_rst = ap_const_logic_0) and (ack_out = ap_const_logic_0) and (vld_out_int = ap_const_logic_1)) then
            apdone_blk <= ap_const_logic_1;
        else
            apdone_blk <= ap_const_logic_0;   
        end if; 
    end process;

end behav;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regslice_reverse is
GENERIC (DataWidth : INTEGER := 32);
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;

    data_in : IN STD_LOGIC_VECTOR (DataWidth-1 downto 0);
    vld_in : IN STD_LOGIC;
    ack_in : OUT STD_LOGIC;
    data_out : OUT STD_LOGIC_VECTOR (DataWidth-1 downto 0);
    vld_out : OUT STD_LOGIC;
    ack_out : IN STD_LOGIC;
    apdone_blk : OUT STD_LOGIC );
end;

architecture behav of regslice_reverse is 
    constant W : INTEGER := DataWidth+1;
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    signal idata : STD_LOGIC_VECTOR (W-1 downto 0);
    signal istop : STD_LOGIC;
    signal odata : STD_LOGIC_VECTOR (W-1 downto 0);
    signal ostop : STD_LOGIC;

    signal ack_in_int : STD_LOGIC;

    component regslice_ibuf IS
    generic (
        W : INTEGER );
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        idata : IN STD_LOGIC_VECTOR (W-1 downto 0);
        istop : OUT STD_LOGIC;
        cdata : OUT STD_LOGIC_VECTOR (W-1 downto 0);
        cstop : IN STD_LOGIC );
    end component;

begin

    regslice_ibuf_inst : component regslice_ibuf 
    generic map (
        W => W)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        idata => idata,
        istop => istop,
        cdata => odata,
        cstop => ostop);


    idata <= (vld_in & data_in); ---???
    ack_in_int <= not(istop);
    ack_in <= ack_in_int;

    vld_out <= odata(W-1);
    data_out <= odata(W-2 downto 0);
    ostop <= not(ack_out);

    apdone_blk_assign_proc : process(ap_rst, ack_in_int)
    begin
        if((ap_rst = ap_const_logic_0) and (ack_in_int = ap_const_logic_0)) then
            apdone_blk <= ap_const_logic_1;
        else
            apdone_blk <= ap_const_logic_0;   
        end if; 
    end process;

end behav;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regslice_both_w1 is
GENERIC (DataWidth : INTEGER := 1);
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;

    data_in : IN STD_LOGIC;
    vld_in : IN STD_LOGIC;
    ack_in : OUT STD_LOGIC;
    data_out : OUT STD_LOGIC;
    vld_out : OUT STD_LOGIC;
    ack_out : IN STD_LOGIC;
    apdone_blk : OUT STD_LOGIC );
end;
architecture behav of regslice_both_w1 is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant ap_const_lv2_1 : STD_LOGIC_VECTOR (1 downto 0) := "01";
    constant ap_const_lv2_2 : STD_LOGIC_VECTOR (1 downto 0) := "10";
    constant ap_const_lv2_3 : STD_LOGIC_VECTOR (1 downto 0) := "11";

    signal B_V_data_1_ack_in : STD_LOGIC;
    signal B_V_data_1_ack_out : STD_LOGIC;
    signal B_V_data_1_state : STD_LOGIC_VECTOR (1 downto 0) := "00";
    signal B_V_data_1_data_in : STD_LOGIC;
    signal B_V_data_1_data_out : STD_LOGIC;
    signal B_V_data_1_vld_in : STD_LOGIC;
    signal B_V_data_1_vld_out : STD_LOGIC;
    signal B_V_data_1_payload_A : STD_LOGIC;
    signal B_V_data_1_payload_B : STD_LOGIC;
    signal B_V_data_1_sel_rd : STD_LOGIC := '0';
    signal B_V_data_1_sel_wr : STD_LOGIC := '0';
    signal B_V_data_1_sel : STD_LOGIC;
    signal B_V_data_1_load_A : STD_LOGIC;
    signal B_V_data_1_load_B : STD_LOGIC;
    signal B_V_data_1_state_cmp_full : STD_LOGIC;

begin

    B_V_data_1_sel_rd_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                B_V_data_1_sel_rd <= ap_const_logic_0;
            else
                if (((ap_const_logic_1 = B_V_data_1_vld_out) and (ap_const_logic_1 = B_V_data_1_ack_out))) then 
                    B_V_data_1_sel_rd <= not(B_V_data_1_sel_rd);
                end if; 
            end if;
        end if;
    end process;

    B_V_data_1_sel_wr_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                B_V_data_1_sel_wr <= ap_const_logic_0;
            else
                if (((ap_const_logic_1 = B_V_data_1_vld_in) and (ap_const_logic_1 = B_V_data_1_ack_in))) then 
                    B_V_data_1_sel_wr <= not(B_V_data_1_sel_wr);
                end if; 
            end if;
        end if;
    end process;

    B_V_data_1_state_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                B_V_data_1_state <= ap_const_lv2_0;
            else
                if ((((ap_const_lv2_3 = B_V_data_1_state) and (ap_const_logic_0 = B_V_data_1_vld_in) and (ap_const_logic_1 = B_V_data_1_ack_out)) or ((ap_const_lv2_2 = B_V_data_1_state) and (ap_const_logic_0 = B_V_data_1_vld_in)))) then 
                    B_V_data_1_state <= ap_const_lv2_2;
                elsif ((((ap_const_lv2_1 = B_V_data_1_state) and (ap_const_logic_0 = B_V_data_1_ack_out)) or ((ap_const_lv2_3 = B_V_data_1_state) and (ap_const_logic_0 = B_V_data_1_ack_out) and (ap_const_logic_1 = B_V_data_1_vld_in)))) then 
                    B_V_data_1_state <= ap_const_lv2_1;
                elsif ((((ap_const_lv2_1 = B_V_data_1_state) and (ap_const_logic_1 = B_V_data_1_ack_out)) or (not(((ap_const_logic_0 = B_V_data_1_ack_out) and (ap_const_logic_1 = B_V_data_1_vld_in))) and not(((ap_const_logic_0 = B_V_data_1_vld_in) and (ap_const_logic_1 = B_V_data_1_ack_out))) and (ap_const_lv2_3 = B_V_data_1_state)) or ((ap_const_lv2_2 = B_V_data_1_state) and (ap_const_logic_1 = B_V_data_1_vld_in)))) then 
                    B_V_data_1_state <= ap_const_lv2_3;
                else 
                    B_V_data_1_state <= ap_const_lv2_2;
                end if; 
            end if;
        end if;
    end process;

    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = B_V_data_1_load_A)) then
                B_V_data_1_payload_A <= B_V_data_1_data_in;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = B_V_data_1_load_B)) then
                B_V_data_1_payload_B <= B_V_data_1_data_in;
            end if;
        end if;
    end process;

    B_V_data_1_data_out_assign_proc : process(B_V_data_1_payload_A, B_V_data_1_payload_B, B_V_data_1_sel)
    begin
        if ((ap_const_logic_1 = B_V_data_1_sel)) then 
            B_V_data_1_data_out <= B_V_data_1_payload_B;
        else 
            B_V_data_1_data_out <= B_V_data_1_payload_A;
        end if; 
    end process;

    B_V_data_1_ack_in <= B_V_data_1_state(1);

    B_V_data_1_load_A <= (not(B_V_data_1_sel_wr) and B_V_data_1_state_cmp_full);
    B_V_data_1_load_B <= (B_V_data_1_state_cmp_full and B_V_data_1_sel_wr);
    B_V_data_1_sel <= B_V_data_1_sel_rd;
    B_V_data_1_state_cmp_full <= '0' when (B_V_data_1_state = ap_const_lv2_1) else '1';

    B_V_data_1_vld_out <= B_V_data_1_state(0);

    B_V_data_1_vld_in <= vld_in;
    B_V_data_1_data_in <= data_in;
    ack_in <= B_V_data_1_ack_in;
    
    vld_out <= B_V_data_1_vld_out;
    data_out <= B_V_data_1_data_out;
    B_V_data_1_ack_out <= ack_out;

    apdone_blk_assign_proc : process(B_V_data_1_state, ack_out)
    begin
        if(((B_V_data_1_state = ap_const_lv2_3) and (ack_out = ap_const_logic_0)) or (B_V_data_1_state = ap_const_lv2_1)) then
            apdone_blk <= ap_const_logic_1;
        else
            apdone_blk <= ap_const_logic_0;   
        end if; 
    end process;

end behav;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regslice_forward_w1 is
GENERIC (DataWidth : INTEGER := 1);
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;

    data_in : IN STD_LOGIC;
    vld_in : IN STD_LOGIC;
    ack_in : OUT STD_LOGIC;
    data_out : OUT STD_LOGIC;
    vld_out : OUT STD_LOGIC;
    ack_out : IN STD_LOGIC;
    apdone_blk : OUT STD_LOGIC );
end;

architecture behav of regslice_forward_w1 is 
    constant W : INTEGER := 2;
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    signal idata : STD_LOGIC_VECTOR (W-1 downto 0);
    signal istop : STD_LOGIC;
    signal odata : STD_LOGIC_VECTOR (W-1 downto 0);
    signal ostop : STD_LOGIC;

    signal vld_out_int : STD_LOGIC;
    
    component regslice_obuf IS
    generic (
        W : INTEGER );
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        cdata : IN STD_LOGIC_VECTOR (W-1 downto 0);
        cstop : OUT STD_LOGIC;
        odata : OUT STD_LOGIC_VECTOR (W-1 downto 0);
        ostop : IN STD_LOGIC );
    end component;

begin

    regslice_obuf_inst : component regslice_obuf 
    generic map (
        W => W)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        cdata => idata,
        cstop => istop,
        odata => odata,
        ostop => ostop);

    idata <= (vld_in & data_in);
    ack_in <= not(istop);

    vld_out_int <= odata(W-1);
    vld_out <= vld_out_int;
    data_out <= odata(0);
    ostop <= not(ack_out);

    apdone_blk_assign_proc : process(ap_rst, ack_out, vld_out_int)
    begin
        if((ap_rst = ap_const_logic_0) and (ack_out = ap_const_logic_0) and (vld_out_int = ap_const_logic_1)) then
            apdone_blk <= ap_const_logic_1;
        else
            apdone_blk <= ap_const_logic_0;   
        end if; 
    end process;

end behav;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regslice_reverse_w1 is
GENERIC (DataWidth : INTEGER := 1);
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;

    data_in : IN STD_LOGIC;
    vld_in : IN STD_LOGIC;
    ack_in : OUT STD_LOGIC;
    data_out : OUT STD_LOGIC;
    vld_out : OUT STD_LOGIC;
    ack_out : IN STD_LOGIC;
    apdone_blk : OUT STD_LOGIC );
end;

architecture behav of regslice_reverse_w1 is 
    constant W : INTEGER := 2; 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    signal idata : STD_LOGIC_VECTOR (W-1 downto 0);
    signal istop : STD_LOGIC;
    signal odata : STD_LOGIC_VECTOR (W-1 downto 0);
    signal ostop : STD_LOGIC;

    signal ack_in_int : STD_LOGIC;

    component regslice_ibuf IS
    generic (
        W : INTEGER );
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        idata : IN STD_LOGIC_VECTOR (W-1 downto 0);
        istop : OUT STD_LOGIC;
        cdata : OUT STD_LOGIC_VECTOR (W-1 downto 0);
        cstop : IN STD_LOGIC );
    end component;

begin

    regslice_ibuf_inst : component regslice_ibuf 
    generic map (
        W => W)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        idata => idata,
        istop => istop,
        cdata => odata,
        cstop => ostop);


    idata <= (vld_in & data_in); ---???
    ack_in_int <= not(istop);
    ack_in <= ack_in_int;

    vld_out <= odata(W-1);
    data_out <= odata(0);
    ostop <= not(ack_out);

    apdone_blk_assign_proc : process(ap_rst, ack_in_int)
    begin
        if((ap_rst = ap_const_logic_0) and (ack_in_int = ap_const_logic_0)) then
            apdone_blk <= ap_const_logic_1;
        else
            apdone_blk <= ap_const_logic_0;   
        end if; 
    end process;

end behav;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regslice_ibuf is
GENERIC (W : INTEGER := 32);
port (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;

    idata : IN STD_LOGIC_VECTOR (W-1 downto 0);
    istop : OUT STD_LOGIC;
    cdata : OUT STD_LOGIC_VECTOR (W-1 downto 0);
    cstop : IN STD_LOGIC );
end;

architecture behav of regslice_ibuf is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';

    signal ireg : STD_LOGIC_VECTOR (W-1 downto 0) := (others=>'0');
    signal istop_int : STD_LOGIC := '1';
begin
    istop_int <= '1' when (reset = '1') else ireg(W-1);
    istop <= istop_int;
    cdata <= ireg when (istop_int = '1') else idata; ---???

    ireg_proc : process(clk)
    begin
        if (clk'event and clk =  '1') then
            if (reset = '1') then
                ireg <= (others=>'0');
            else
                if ((cstop = '0') and (ireg(W-1) = '1')) then
                    ireg <= (others=>'0');
                elsif ((cstop = '1') and (ireg(W-1) = '0')) then
                    ireg <= idata; --- Yes: load buffer
                end if;
            end if;
        end if;
    end process;

end behav; 


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regslice_obuf is
GENERIC (W : INTEGER := 32);
port (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;

    cdata : IN STD_LOGIC_VECTOR (W-1 downto 0);
    cstop : OUT STD_LOGIC;
    odata : OUT STD_LOGIC_VECTOR (W-1 downto 0);
    ostop : IN STD_LOGIC );
end;

architecture behav of regslice_obuf is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';

    signal cstop_int : STD_LOGIC;
    signal odata_int : STD_LOGIC_VECTOR (W-1 downto 0); 
begin
    cstop_int <= ap_const_logic_1 when (reset = '1') else (odata_int(W-1) and ostop); ---??? output

    odata_proc : process(clk)
    begin
        if (clk'event and clk =  '1') then
            if (reset = '1') then
                odata_int <= (others=>'0');
            else
                if (cstop_int = '0') then
                    odata_int <= cdata; --- Yes: load buffer
                end if;
            end if;
        end if;
    end process;

    odata <= odata_int;
    cstop <= cstop_int;
end behav; 
    
    
