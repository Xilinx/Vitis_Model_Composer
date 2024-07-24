-- Copyright (C) 2024, Advanced Micro Devices, Inc.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.TYPES_PKG.all;

library UNISIM;
use UNISIM.VComponents.all;

entity SSR_FIR_TEST is
  generic(OX,OY:INTEGER:=0;                                           -- Coordinates of the lower left corner DSPx8, use -2147483648 if you do not want floorplanning
          FAMILY:INTEGER:=3;                                          -- use 1 for 7-series, 2 for US/US+ and 3 for Versal
          DDR:BOOLEAN:=TRUE;          -- DDR implementation for Versal -3 clock rates over 872MHz
          SSR:INTEGER:=8; -- for 8Gsps in Versal speed grade -3
--          SSR:INTEGER:=9; -- for 8Gsps in US+ speed grade -3
--          SSR:INTEGER:=11; -- for 8Gsps in 7-series speed grade -3
          COEFFICIENT:REAL_VECTOR(0 to 15):=(1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0,16.0);
--          COEFFICIENT:REAL_VECTOR(0 to 23):=(1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0,16.0,17.0,18.0,19.0,20.0,21.0,22.0,23.0,24.0);
          I_HIGH:INTEGER:=7;
          I_LOW:INTEGER:=-8;
          C_HIGH:INTEGER:=9;
          C_LOW:INTEGER:=-8;
          O_HIGH:INTEGER:=19;
          O_LOW:INTEGER:=-8;
          ROUNDING:BOOLEAN:=TRUE;
          SYMMETRY:STRING:="OS");     -- Filter Symmetry, use "ES" for Even-Symmetric, "OS" for Odd-Symmetric and "NS" for Non-Symmetric
  port(CLKIN:in STD_LOGIC;
       I:in SFIXED_VECTOR(0 to SSR-1,I_HIGH downto I_LOW);
       VI:in BOOLEAN;
       O:out SFIXED_VECTOR(0 to SSR-1,O_HIGH downto O_LOW);
       VO:out BOOLEAN);
end SSR_FIR_TEST;

architecture TEST of SSR_FIR_TEST is
  signal CLK,CLKH:STD_LOGIC;
  signal ID:SFIXED_VECTOR(0 to SSR-1,I_HIGH downto I_LOW):=(others=>(others=>'0'));
  signal VID:BOOLEAN:=FALSE;
begin
  i1:if DDR generate
       b2:MBUFGCE_DIV port map(I=>CLKIN,
                               CE=>'1',
                               CLR=>'0',
                               CLRB_LEAF=>'1',
                               O1=>CLK,
                               O2=>CLKH);
      end;
      else generate
        CLK<=CLKIN;
        CLKH<='0';
      end generate;

  process(CLK)
  begin
    if rising_edge(CLK) then
      ID<=I;
      VID<=VI;
    end if;
  end process;
  
  u1:entity work.SSR_FIR generic map(OX=>OX,
                                     OY=>OY,
                                     FAMILY=>FAMILY,
                                     DDR=>DDR,
                                     COEFFICIENT=>COEFFICIENT,
                                     C_HIGH=>C_HIGH,
                                     C_LOW=>C_LOW,
                                     ROUNDING=>ROUNDING,
                                     SYMMETRY=>SYMMETRY)
                         port map (CLK=>CLK,
                                   CLKH=>CLKH,
                                   I=>ID,
                                   VI=>VID,
                                   O=>O,
                                   VO=>VO);
end TEST;