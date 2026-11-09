--
-- Copyright © Advanced Micro Devices, Inc., or its affiliates.
--
-- SPDX-License-Identifier: MIT
--
-- Portions of this content consists of AI generated content.
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.fixed_pkg.all;  -- VHDL-2008 IEEE standard SFIXED type and functions
use work.cfixed_pkg.all; -- user package, SFIXED_VECTOR, SFIXED_MATRIX and many other goodies

entity SSR_FIR is
  generic(OX,OY:INTEGER:=-2147483648; -- Coordinates of the lower left corner DSPx8, use -2147483648 if you do not want floorplanning
          FAMILY:INTEGER:=3;          -- use 1 for 7-series, 2 for US/US+ and 3 for Versal
          DDR:BOOLEAN:=FALSE;         -- DDR implementation for Versal -3 clock rates over 872MHz
          COEFFICIENT:REAL_MATRIX;    -- Number of Rows=COEFFICIENT'length
          C_HIGH:INTEGER:=0;
          C_LOW:INTEGER:=-17;
          ROUNDING:BOOLEAN:=FALSE;
          ANTI:BOOLEAN:=FALSE;        -- for anti-symmetric filters, when ANTI=TRUE and SYMMETRY="OS" the center tap must be 0.0
          SYMMETRY:STRING:="ES");     -- Filter Symmetry, use "ES" for Even-Symmetric, "OS" for Odd-Symmetric and "NS" for Non-Symmetric
  port(CLK:in STD_LOGIC;
       CLKH:in STD_LOGIC:='0';        -- if DDR=FALSE can be left unconnected
       I:in SFIXED_VECTOR;
       VI:in BOOLEAN:=TRUE;
       CSA:in UNSIGNED:="0";          -- Coefficient Set Address, CSA'length must be equal to LOG2(COEFFICIENT'length(1))
       O:out SFIXED_VECTOR;
       VO:out BOOLEAN);
end SSR_FIR;

architecture TEST of SSR_FIR is
  constant COEFFICIENT_SETS:INTEGER:=COEFFICIENT'length;
  constant TAPS:INTEGER:=COEFFICIENT(COEFFICIENT'low)'length;
  constant SSR:INTEGER:=I'length;
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
  type AC_VECTOR is array(INTEGER range <>) of STD_LOGIC_VECTOR(FAMILY/3*4+29 downto 0);
  type PC_VECTOR is array(INTEGER range <>) of STD_LOGIC_VECTOR(FAMILY/3*10+47 downto 0);
  signal SW,SE:SFIXED_MATRIX(0 to TAPS-1)(0 to SSR-1)(I(I'low)'range);
  function LATENCY(SSR:INTEGER;SYMMETRY:STRING;TAPS:INTEGER) return INTEGER is
  begin
    if SSR=1 then
      if SYMMETRY="ES" then
        return TAPS+4;
      elsif SYMMETRY="OS" then
        return TAPS+4-BOOLEAN'pos(ANTI);
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
        return TAPS+3-BOOLEAN'pos(ANTI);
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
begin
  assert I'length=O'length report "Ports I and O must have the same length!" severity warning;
  assert CSA'length=MAX(LOG2(COEFFICIENT'length(1)),1) report "Inconsistent CSA length!" severity warning;
  assert not (ANTI and SYMMETRY="NS") report "ANTI=TRUE has no effect for SYMMETRY=""NS"" - anti-symmetric pairs require ES or OS symmetry" severity warning;
  assert SSR=1 or 2**LOG2(SSR)=SSR report "SSR must be 1 or a power of 2 - non-power-of-2 SSR causes diagonal register misalignment in the SSR>1 accumulation chain" severity failure;
  -- For ES/OS: the SE reverse-delay index DI(-LDI-1+SSR+J) becomes invalid
  -- when SSR > TAPS (ES) or SSR >= TAPS (OS), where TAPS=COEFFICIENT'length.
  -- ES rule: 2*SSR <= NUM_TAPS  =>  SSR <= COEFFICIENT'length
  -- OS rule: 2*SSR <  NUM_TAPS  =>  SSR <  COEFFICIENT'length
  assert SYMMETRY="NS" or SSR<=TAPS-BOOLEAN'pos(SYMMETRY="OS") report "For ES: SSR must be <= NUM_TAPS/2. For OS: SSR must be < (NUM_TAPS+1)/2. Increase TAPS or use NS." severity failure;
  -- For ES/OS, the pre-adder computes D+A. Both D and A carry data_width-bit samples.
  -- Their sum requires data_width+1 bits; this must fit the DSP pre-adder AD output.
  -- Documented D-port (= AD output) widths per generation (sources below):
  --   FAMILY=1 (DSP48E1, UG479): D port = 25 bits → AD = 25 → data_width ≤ 24.
  --   FAMILY=2 (DSP48E2, UG579): D port = 27 bits → AD = 27 → data_width ≤ 26.
  --   FAMILY=3 (DSPx8,  AM004 ): D port = 27 bits → AD = 27 → data_width ≤ 26.
  -- Formula: AD_width = FAMILY/2*2+25 (25 for FAM=1, 27 for FAM=2/3).
  --          safe data_width = AD_width - 1 = FAMILY/2*2+24.
  -- Gap-8 boundary test (2026-06-15) confirmed FAM=1 at 29 bits and FAM=2 at 29 bits fail;
  -- the prior assertion (FAMILY/3*26+(1-FAMILY/3)*29) was wrong for FAM=1 and FAM=2.
  assert SYMMETRY="NS" or I(I'low)'length <= FAMILY/2*2+24
    report "For ES/OS: data width (I_HIGH-I_LOW+1=" & INTEGER'image(I(I'low)'length) & ") exceeds the DSP pre-adder limit (" & INTEGER'image(FAMILY/2*2+24) & " bits for FAMILY=" & INTEGER'image(FAMILY) & "). Reduce I_HIGH-I_LOW, or use SYMMETRY=""NS""."
    severity failure;
  -- For SSR>1, the DI delay buffer has depth LDI=TAPS-1. TAPS=1 gives LDI=0
  -- (null range), which is not supported by xsim or synthesis.
  assert SSR=1 or TAPS>=2
    report "TAPS must be >= 2 when SSR > 1: TAPS=1 creates a null-range DI buffer (LDI=0). No practical use case exists for SSR>1 with a single-tap FIR."
    severity failure;
  i1:if SSR=1 generate
       signal DI:SFIXED(I(I'low)'range);
       signal AC:AC_VECTOR(0 to TAPS);
       signal PC:PC_VECTOR(0 to TAPS);
       signal CS:UNSIGNED_VECTOR(0 to TAPS)(CSA'range):=(others=>(others=>'0'));
       function DSIZE(TAPS:INTEGER;SYMMETRY:STRING) return INTEGER is
       begin
         if SYMMETRY="ES" then
           return 2*TAPS;
         elsif SYMMETRY="OS" then
           return 2*TAPS-1;
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
                                      I=>I(I'low),
                                      O=>DI);
-- DSPx8 Array
       AC(0)<=STD_LOGIC_VECTOR(TO_SIGNED(0,AC(0)'length));
       PC(0)<=STD_LOGIC_VECTOR(TO_SIGNED(0,PC(0)'length));
       CS(0)<=CSA;
       lj:for J in 0 to TAPS-1-BOOLEAN'pos(ANTI and SYMMETRY="OS") generate
            signal ALUMODE:STD_LOGIC_VECTOR(3 downto 0);
            signal INMODE:STD_LOGIC_VECTOR(4 downto 0);
            signal OPMODE:STD_LOGIC_VECTOR(8 downto 0);
            signal A,D:SFIXED(I(I'low)'range);
            signal B:SFIXED(C_high downto C_low);
            signal C,P:SFIXED(LOG2(TAPS)+I(I'low)'high+C_HIGH+1 downto I(I'low)'low+C_LOW); -- must not be longer than 48/58 bits!
            signal CE:STD_LOGIC;
          begin
            A<=I(I'low) when J=0 else (others=>'0');
            C<=TO_SFIXED(2.0**(C'low-O(O'low)'low-1),C) when ROUNDING and (J=0) else TO_SFIXED(0.0,C);
            D<=(others=>'0') when SYMMETRY="NS" else DI;
            ALUMODE<=4x"3" when ANTI else 4x"0";
            INMODE<=5x"18" when ANTI and (SYMMETRY="OS") and (J=TAPS-1) else 5x"1C" when ANTI else
                    5x"10" when (SYMMETRY="OS") and (J=TAPS-1) else 5x"14"; -- A2*B1 when (SYMMETRY="OS") and (J=TAPS-1) else (D+A1)*B1
            OPMODE<=9x"035" when J=0 else 9x"015"; -- PCOUT=C-(D+A)*B when J=0 else PCIN-(D+A)*B
            CE<='1' when VI else '0';
       ia:if COEFFICIENT'length=1 generate
            B<=TO_SFIXED(COEFFICIENT(TO_INTEGER(CS(J+1-BOOLEAN'pos(SYMMETRY="NS"))))(COEFFICIENT(COEFFICIENT'low)'low+J),C_HIGH,C_LOW);
            CS(J+1)<=CS(J);
          else generate
            process(CLK)
            begin
              if rising_edge(CLK) then
                B<=TO_SFIXED(COEFFICIENT(TO_INTEGER(CS(J+1-BOOLEAN'pos(SYMMETRY="NS"))))(COEFFICIENT(COEFFICIENT'low)'low+J),C_HIGH,C_LOW);
                CS(J+1)<=CS(J);
              end if;
            end process;
          end generate;
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
                                                   B=>B,
                                                   C=>C,
                                                   D=>D,
                                                   ACIN=>AC(J),
                                                   ALUMODE=>ALUMODE,
                                                   INMODE=>INMODE,
                                                   OPMODE=>OPMODE,
                                                   PCIN=>PC(J),
                                                   ACOUT=>AC(J+1),
                                                   PCOUT=>PC(J+1),
                                                   P=>P);
-- Output Samples                                                   
             il:if J=TAPS-1-BOOLEAN'pos(ANTI and SYMMETRY="OS") generate 
                   process(P)
                   begin
                     O(O'low)<=RESIZE(P,O(O'low));
                   end process;
                end generate;
            end generate;
     end;
     else generate
       signal DI:SFIXED_VECTOR(-LDI to -1)(I(I'low)'range):=(others=>(others=>'0'));
       signal WI,EI:SFIXED_VECTOR(1 to TAPS-1)(I(I'low)'range);
       signal RSW:SFIXED_MATRIX(0 to TAPS-2)(0 to SSR-2)(I(I'low)'range):=(others=>(others=>(others=>'0')));
       signal RSE:SFIXED_MATRIX(0 to TAPS-2)(1 to SSR-1)(I(I'low)'range):=(others=>(others=>(others=>'0')));
       signal vP:SFIXED_VECTOR(0 to SSR-1)(LOG2(TAPS)+I(I'low)'high+C_HIGH+1 downto I(I'low)'low+C_LOW);
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
               DI(K)<=I(I'low+K+SSR);
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
                 -- Reverse delay: DI(-LDI-1+SSR+J) accesses the symmetric
                 -- counterpart sample. Guard against OOB when SSR >= TAPS_internal
                 -- (i.e. -LDI-1+SSR+J >= 0). For the degenerate center-tap case
                 -- use DI(-J) so D+B=2D; with the halved center coefficient this
                 -- gives the correct full-coefficient result. For ANTI=TRUE the
                 -- center coefficient is 0 so this path has no effect.
                 valid_rd:if (-LDI-1+SSR+J) < 0 generate
                      rd:entity work.SDELAY generic map(SIZE=>J,
                                                        DDR=>DDR)
                                            port map(CLK=>CLK,
                                                     CLKH=>CLKH,
                                                     I=>DI(-LDI-1+SSR+J),
                                                     O=>EI(J));
                    end generate;
                 center_rd:if (-LDI-1+SSR+J) >= 0 generate
                      rd:entity work.SDELAY generic map(SIZE=>J,
                                                        DDR=>DDR)
                                            port map(CLK=>CLK,
                                                     CLKH=>CLKH,
                                                     I=>DI(-J),
                                                     O=>EI(J));
                    end generate;
               end generate;
          end generate;
-- Pipelining Array Registers
       jl:for J in 0 to TAPS-2 generate
            lw:for K in 0 to SSR-2 generate
                 process(CLK)
                 begin
                   if rising_edge(CLK) then
                     RSW(J)(K)<=SW(J)(K);
                   end if;
                 end process;
               end generate;

            ns:if SYMMETRY/="NS" generate
                 le:for K in 1 to SSR-1 generate
                      process(CLK)
                      begin
                        if rising_edge(CLK) then
                          RSE(J)(K)<=SE(J)(K);
                        end if;
                      end process;
                    end generate;
               end generate;
          end generate;
-- DSPx8 Array
       lk:for K in 0 to SSR-1 generate
            signal PC:PC_VECTOR(0 to TAPS);
            signal CS:UNSIGNED_VECTOR(0 to TAPS)(CSA'range):=(others=>(others=>'0'));
          begin
            PC(0)<=STD_LOGIC_VECTOR(TO_SIGNED(0,PC(0)'length));
            CS(0)<=CSA;
            lj:for J in 0 to TAPS-1-BOOLEAN'pos(ANTI and SYMMETRY="OS") generate
                 signal ALUMODE:STD_LOGIC_VECTOR(3 downto 0);
                 signal INMODE:STD_LOGIC_VECTOR(4 downto 0);
                 signal OPMODE:STD_LOGIC_VECTOR(8 downto 0);
                 signal D:SFIXED(I(I'low)'range);
                 signal C,P:SFIXED(vP(vP'low)'range);
                 signal B:SFIXED(C_high downto C_low);
               begin
-- MIN/MAX workaround for QuestaSim bug
                 SW(J)(K)<=I(I'low+K) when J=0 else
                           WI(work.cfixed_pkg.MAX(J,1)) when K=0 else
                           RSW(work.cfixed_pkg.MAX(J-1,0))(work.cfixed_pkg.MAX(K-1,0));
                 ns:if SYMMETRY/="NS" generate
                      SE(J)(K)<=DI(-LDI+K) when J=0 else
                                EI(work.cfixed_pkg.MAX(J,1)) when K=SSR-1 else
                                RSE(work.cfixed_pkg.MAX(J-1,0))(work.cfixed_pkg.MIN(K+1,SSR-1));
                    end generate;

                 C<=TO_SFIXED(2.0**(C'low-O(O'low)'low-1),C) when ROUNDING and (J=0) else TO_SFIXED(0.0,C);
                 D<=(others=>'0') when SYMMETRY="NS" else SE(J)(K);
                 ALUMODE<=4x"3" when ANTI else 4x"0";
                 INMODE<=5x"13" when ANTI and (SYMMETRY="OS") and (J=TAPS-1) else 5x"1D" when ANTI else
                         5x"11" when (SYMMETRY="OS") and (J=TAPS-1) else 5x"15"; -- A2*B1 when (SYMMETRY="OS") and (J=TAPS-1) else (D+A1)*B1
                 OPMODE<=9x"035" when J=0 else 9x"015"; -- PCOUT=C+(D+A)*B when J=0 else PCIN+(D+A)*B
                 ia:if COEFFICIENT'length=1 generate
                      B<=TO_SFIXED(COEFFICIENT(TO_INTEGER(CS(J+1-BOOLEAN'pos(SYMMETRY="NS"))))(COEFFICIENT(COEFFICIENT'low)'low+J),C_HIGH,C_LOW);
                      CS(J+1)<=CS(J);
                    else generate
                      process(CLK)
                      begin
                        if rising_edge(CLK) then
                          B<=TO_SFIXED(COEFFICIENT(TO_INTEGER(CS(J)))(COEFFICIENT(COEFFICIENT'low)'low+J),C_HIGH,C_LOW);
                          CS(J+1)<=CS(J);
                        end if;
                      end process;
                    end generate;
                 jk:entity work.DSPx8_WRAPPER generic map(X=>OX+K,
                                                          Y=>OY+J,
                                                          FAMILY=>FAMILY,
                                                          AMULTSEL=>AMULTSEL(SYMMETRY)) --"A" for Non-Symmetric FIR else "AD"
                                              port map (CLK=>CLK,
                                                        A=>SW(J)(K),
                                                        B=>B,
                                                        C=>C,
                                                        D=>D,
                                                        ALUMODE=>ALUMODE,
                                                        INMODE=>INMODE,
                                                        OPMODE=>OPMODE,
                                                        PCIN=>PC(J),
                                                        PCOUT=>PC(J+1),
                                                        P=>P);
-- SSR Output Samples                                                   
                 il:if J=TAPS-1-BOOLEAN'pos(ANTI and SYMMETRY="OS") generate
                      vP(K)<=P;
                    end generate;
               end generate;
          end generate;
       process(vP)
       begin
         for K in vP'range loop
           O(O'low+K)<=RESIZE(vP(K),O(O'low+K));
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
