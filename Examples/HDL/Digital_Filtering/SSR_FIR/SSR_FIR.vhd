-- Copyright (C) 2024, Advanced Micro Devices, Inc.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.TYPES_PKG.all;

entity SSR_FIR is
  generic(OX,OY:INTEGER:=-2147483648; -- Coordinates of the lower left corner DSPx8, use -2147483648 if you do not want floorplanning
          FAMILY:INTEGER:=3;          -- use 1 for 7-series, 2 for US/US+ and 3 for Versal
          DDR:BOOLEAN:=FALSE;         -- DDR implementation for Versal -3 clock rates over 872MHz
          COEFFICIENT:REAL_VECTOR;    -- Number of Rows=COEFFICIENT'length
          C_HIGH:INTEGER:=0;
          C_LOW:INTEGER:=-17;
          ROUNDING:BOOLEAN:=FALSE;
          SYMMETRY:STRING:="ES");     -- Filter Symmetry, use "ES" for Even-Symmetric, "OS" for Odd-Symmetric and "NS" for Non-Symmetric
  port(CLK:in STD_LOGIC;
       CLKH:in STD_LOGIC:='0';        -- if DDR=FALSE can be left unconnected
       I:in SFIXED_VECTOR;
       VI:in BOOLEAN:=TRUE;
       O:out SFIXED_VECTOR;
       VO:out BOOLEAN);
end SSR_FIR;

architecture TEST of SSR_FIR is
  constant SSR:INTEGER:=I'length(1); -- Number of Columns
  constant TAPS:INTEGER:=COEFFICIENT'length; -- Number of Rows
  function DIL(SYMMETRY:STRING;TAPS:INTEGER) return INTEGER is
  begin
    if SYMMETRY="ES" then
      return 2*TAPS-1;
    elsif SYMMETRY="OS" then
      return 2*TAPS-2;
    elsif SYMMETRY="NS" then
      return TAPS-1;
    else
      assert FALSE report "SYMMETRY must be eiter ""ES"", ""OS"" or ""NS""!" severity warning;
      return 0;
    end if;
  end;
  constant LDI:INTEGER:=DIL(SYMMETRY,TAPS);
-- these two type definitions overload the ones in TYPES_PKG, they are slightly different, this is a workaround for Vivado Sim VHDL-2008 limited support
  type SFIXED_VECTOR is array(INTEGER range <>) of SFIXED(I'range(2));
  type SFIXED_MATRIX is array(INTEGER range <>,INTEGER range <>) of SFIXED(I'range(2));
  type AC_VECTOR is array(INTEGER range <>) of STD_LOGIC_VECTOR(FAMILY/3*4+29 downto 0);
  type PC_VECTOR is array(INTEGER range <>) of STD_LOGIC_VECTOR(FAMILY/3*10+47 downto 0);
  signal SW,SE:SFIXED_MATRIX(0 to TAPS-1,0 to SSR-1);
  function LATENCY(SSR:INTEGER;SYMMETRY:STRING;TAPS:INTEGER) return INTEGER is
  begin
    if SSR=1 then
      if SYMMETRY="ES" then
        return TAPS+4;
      elsif SYMMETRY="OS" then
        return TAPS+4;
      elsif SYMMETRY="NS" then
        return TAPS+3;
      else
        assert FALSE report "SYMMETRY must be eiter ""ES"", ""OS"" or ""NS""!" severity warning;
        return 0;
      end if;
    else
      if SYMMETRY="ES" then
        return TAPS+3;
      elsif SYMMETRY="OS" then
        return TAPS+3;
      elsif SYMMETRY="NS" then
        return TAPS+2;
      else
        assert FALSE report "SYMMETRY must be eiter ""ES"", ""OS"" or ""NS""!" severity warning;
        return 0;
      end if;
    end if;
  end;
  function A_INPUT(J:INTEGER) return STRING is
  begin
    if J=0 then
      return "DIRECT";
    else
      return "CASCADE";
    end if;
  end;
  function AMULTSEL(SYMMETRY:STRING) return STRING is
  begin
    if SYMMETRY="ES" then
      return "AD";
    elsif SYMMETRY="OS" then
      return "AD";
    elsif SYMMETRY="NS" then
      return "A";
    else
      assert FALSE report "SYMMETRY must be eiter ""ES"", ""OS"" or ""NS""!" severity warning;
      return "A";
    end if;
  end;
  signal II:SFIXED_VECTOR(I'range(1));
begin
  assert I'length=O'length report "Ports I and O must have the same length!" severity warning;
  li:for L in I'range(1) generate
       II(L)<=GET(I,L);
     end generate;
  i1:if SSR=1 generate
       signal DI:SFIXED(I'range(2));
       signal AC:AC_VECTOR(0 to TAPS);
       signal PC:PC_VECTOR(0 to TAPS);
       function DSIZE(TAPS:INTEGER;SYMMETRY:STRING) return INTEGER is
       begin
         if SYMMETRY="ES" then
           return 2*TAPS-1;
         elsif SYMMETRY="OS" then
           return 2*TAPS-2;
         elsif SYMMETRY="NS" then
           return 0;
         else
           assert FALSE report "SYMMETRY must be eiter ""ES"", ""OS"" or ""NS""!" severity warning;
           return 0;
         end if;
       end;
     begin
       id:entity work.SDELAY generic map(SIZE=>DSIZE(TAPS,SYMMETRY),
                                         DDR=>DDR)
                             port map(CLK=>CLK,
                                      CLKH=>CLKH,
                                      I=>II(I'low),
                                      O=>DI);
-- DSPx8 Array
       AC(0)<=STD_LOGIC_VECTOR(TO_SIGNED(0,AC(0)'length));
       PC(0)<=STD_LOGIC_VECTOR(TO_SIGNED(0,PC(0)'length));
       lj:for J in 0 to TAPS-1 generate
            signal INMODE:STD_LOGIC_VECTOR(4 downto 0);
            signal OPMODE:STD_LOGIC_VECTOR(8 downto 0);
            signal A,D:SFIXED(I'range(2));
            signal C,P:SFIXED(LOG2(TAPS)+I'high(2)+C_HIGH+1 downto I'low(2)+C_LOW); -- must not be longer than 48/58 bits!
            signal CE:STD_LOGIC;
          begin
            A<=II(I'low) when J=0 else (others=>'0');
            C<=TO_SFIXED(2.0**(C'low-O'low(2)-1),C) when ROUNDING and (J=0) else TO_SFIXED(0.0,C);
            D<=(others=>'0') when SYMMETRY="NS" else DI;
            INMODE<=5x"11" when (SYMMETRY="OS") and (J=TAPS-1) else 5x"15"; -- A1*B1 when (SYMMETRY="OS") and (K=TAPS-1) else (D+A1)*B1
            OPMODE<=9x"035" when J=0 else 9x"015"; -- PCOUT=C+(D+A)*B when J=0 else PCIN+(D+A)*B
            CE<='1' when VI else '0';
  
            jk:entity work.DSPx8_WRAPPER generic map(X=>OX,
                                                     Y=>OY+J,
                                                     FAMILY=>FAMILY,
                                                     AREG=>2,
                                                     ACASCREG=>2,
                                                     A_INPUT=>A_INPUT(J),
                                                     AMULTSEL=>AMULTSEL(SYMMETRY)) --"A" for Non-Symmetric FIR else "AD"
                                         port map (CLK=>CLK,
                                                   CEA2=>CE,
                                                   A=>A,
                                                   B=>TO_SFIXED(COEFFICIENT(COEFFICIENT'low+J),C_HIGH,C_LOW),
                                                   C=>C,
                                                   D=>D,
                                                   ACIN=>AC(J),
                                                   INMODE=>INMODE,
                                                   OPMODE=>OPMODE,
                                                   PCIN=>PC(J),
                                                   ACOUT=>AC(J+1),
                                                   PCOUT=>PC(J+1),
                                                   P=>P);
-- Output Samples                                                   
              il:if J=COEFFICIENT'high generate
-- all SET calls targetting the same signal must be located in a single process!
-- SET does not work in QuestaSim!
                   process(P)
                   begin
--                   SET(O,O'low,P);
                     for L in O'range(2) loop
                       O(O'low(1),L)<=P(L);
                     end loop;
                   end process;
                 end generate;
            end generate;
     end;
     else generate
       signal DI:SFIXED_VECTOR(-LDI to -1):=(others=>(others=>'0'));
       signal WI,EI:SFIXED_VECTOR(1 to TAPS-1);
       signal RSW:SFIXED_MATRIX(0 to TAPS-2,0 to SSR-2):=(others=>(others=>(others=>'0')));
       signal RSE:SFIXED_MATRIX(0 to TAPS-2,1 to SSR-1):=(others=>(others=>(others=>'0')));
       type P_SFIXED_VECTOR is array(INTEGER range <>) of SFIXED(LOG2(TAPS)+I'high(2)+C_HIGH+1 downto I'low(2)+C_LOW); -- must not be longer than 48/58 bits!
       signal vP:P_SFIXED_VECTOR(0 to SSR-1);
     begin
-- Input Data Delay Line for SSR Input Samples
       process(CLK)
       begin
         if rising_edge(CLK) then
           if VI then
           for K in DI'range loop
             if K<-SSR then
               DI(K)<=DI(K+SSR);
             else
               DI(K)<=II(I'low+K+SSR);
             end if;
           end loop;
           end if;
         end if;
       end process;
-- Pipelining Triangular Delays
       lj:for J in 1 to TAPS-1 generate
            ld:entity work.SDELAY generic map(SIZE=>J,
                                              DDR=>DDR)
                                  port map(CLK=>CLK,
                                           CLKH=>CLKH,
                                           I=>DI(-J),
                                           O=>WI(J));

            ns:if SYMMETRY/="NS" generate
                 rd:entity work.SDELAY generic map(SIZE=>J,
                                                   DDR=>DDR)
                                       port map(CLK=>CLK,
                                                CLKH=>CLKH,
                                                I=>DI(-LDI-1+SSR+J),
                                                O=>EI(J));
               end generate;
          end generate;
-- Pipelining Array Registers
       jl:for J in 0 to TAPS-2 generate
            lw:for K in 0 to SSR-2 generate
                 process(CLK)
                 begin
                   if rising_edge(CLK) then
                     RSW(J,K)<=SW(J,K);
                   end if;
                 end process;
               end generate;

            ns:if SYMMETRY/="NS" generate
                 le:for K in 1 to SSR-1 generate
                      process(CLK)
                      begin
                        if rising_edge(CLK) then
                          RSE(J,K)<=SE(J,K);
                        end if;
                      end process;
                    end generate;
               end generate;
          end generate;
-- DSPx8 Array
       lk:for K in 0 to SSR-1 generate
            signal PC:PC_VECTOR(0 to TAPS);
          begin
            PC(0)<=STD_LOGIC_VECTOR(TO_SIGNED(0,PC(0)'length));
            lj:for J in 0 to TAPS-1 generate
                 signal INMODE:STD_LOGIC_VECTOR(4 downto 0);
                 signal OPMODE:STD_LOGIC_VECTOR(8 downto 0);
                 signal D:SFIXED(I'range(2));
                 signal C,P:SFIXED(vP(vP'low)'range);
               begin
-- MIN/MAX workaround for QuestaSim bug
                 SW(J,K)<=II(I'low+K) when J=0 else
                          WI(work.TYPES_PKG.MAX(J,1)) when K=0 else
                          RSW(work.TYPES_PKG.MAX(J-1,0),work.TYPES_PKG.MAX(K-1,0));
                 ns:if SYMMETRY/="NS" generate
                      SE(J,K)<=DI(-LDI+K) when J=0 else
                               EI(work.TYPES_PKG.MAX(J,1)) when K=SSR-1 else
                               RSE(work.TYPES_PKG.MAX(J-1,0),work.TYPES_PKG.MIN(K+1,SSR-1));
                    end generate;

                 C<=TO_SFIXED(2.0**(C'low-O'low(2)-1),C) when ROUNDING and (J=0) else TO_SFIXED(0.0,C);
                 D<=(others=>'0') when SYMMETRY="NS" else SE(J,K);
                 INMODE<=5x"11" when (SYMMETRY="OS") and (J=TAPS-1) else 5x"15"; -- A1*B1 when (SYMMETRY="OS") and (K=TAPS-1) else (D+A1)*B1
                 OPMODE<=9x"035" when J=0 else 9x"015"; -- PCOUT=C+(D+A)*B when J=0 else PCIN+(D+A)*B

                 jk:entity work.DSPx8_WRAPPER generic map(X=>OX+K,
                                                          Y=>OY+J,
                                                          FAMILY=>FAMILY,
                                                          AMULTSEL=>AMULTSEL(SYMMETRY)) --"A" for Non-Symmetric FIR else "AD"
                                              port map (CLK=>CLK,
                                                        A=>SW(J,K),
                                                        B=>TO_SFIXED(COEFFICIENT(COEFFICIENT'low+J),C_HIGH,C_LOW),
                                                        C=>C,
                                                        D=>D,
                                                        INMODE=>INMODE,
                                                        OPMODE=>OPMODE,
                                                        PCIN=>PC(J),
                                                        PCOUT=>PC(J+1),
                                                        P=>P);
-- SSR Output Samples                                                   
                 il:if J=COEFFICIENT'high generate
                      vP(K)<=P;
                    end generate;
               end generate;
          end generate;
-- all SET calls targetting the same signal must be located in a single process!
-- SET does not work in QuestaSim!
       process(vP)
       begin
         for K in vP'range loop
--      SET(O,O'low+K,vP(K));
           for L in O'range(2) loop
             O(O'low(1)+K,L)<=vP(K)(L);
           end loop;
         end loop;
       end process;
  end;
  end generate;
-- Data Valid Delay Line    
  bd:entity work.BDELAY generic map(SIZE=>LATENCY(SSR,SYMMETRY,TAPS), -- TAPS+2 when Non-Symmetric else TAPS+3
                                    DDR=>DDR)
                        port map(CLK=>CLK,
                                 CLKH=>CLKH,
                                 I=>VI,
                                 O=>VO);
end TEST;