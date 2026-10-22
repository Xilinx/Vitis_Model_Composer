-- Copyright © Advanced Micro Devices, Inc., or its affiliates. All rights reserved.
-- Portions of this content consists of AI generated content.
-- You may not use this software and documentation (if any) (collectively, the "Materials")
-- except in compliance with the terms and conditions of the Software License Agreement
-- included with the Materials or otherwise as set forth in writing and signed by you and
-- an authorized signatory of AMD. If you do not have a copy of the Software License
-- Agreement, contact your AMD representative for a copy. You agree that you will not
-- reverse engineer or decompile the Materials, in whole or in part, except as allowed by
-- applicable law.
-- THE MATERIALS ARE DISTRIBUTED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
-- REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.FIXED_PKG.all;
use work.CFIXED_PKG.all;

-- =============================================================================
-- TRANSPOSE_SSR_FIR_CHAIN
-- One K-column accumulator chain for the SSR polyphase transpose-form FIR.
-- Instantiated SSR times from TRANSPOSE_SSR_FIR_ROW.
--
-- xsim workaround: concurrent signal assignments and processes inside
-- for-generate use only the first iteration value of the loop parameter.
-- Additionally, signal instances inside for-generate are SHARED across all
-- iterations, causing multiple-driver conflicts (X propagation) when per-stage
-- drivers disagree.  The fix (matching what was done in TRANSPOSE_SSR_FIR_ROW)
-- is to declare ALL signals at architecture level and drive them with a single
-- architecture-level process or concurrent assignment.  Only entity
-- instantiations appear inside the lj:for J generate; port maps are evaluated
-- correctly per iteration in xsim.
-- =============================================================================
entity TRANSPOSE_SSR_FIR_CHAIN is
  generic(OX,OY:INTEGER:=-2147483648; -- Coordinates of the lower left corner DSPx8, use -2147483648 if you do not want floorplanning
          FAMILY:INTEGER:=3;          -- use 1 for 7-series, 2 for US/US+ and 3 for Versal
          DDR:BOOLEAN:=FALSE;         -- DDR implementation to be used only for Versal -3 and clock rates over 872MHz
          COEFFICIENT:REAL_MATRIX;    -- Number of Coefficient Sets=COEFFICIENT'length(1), Number of Taps=COEFFICIENT'length(2)
          C_HIGH:INTEGER:=0;          -- For odd anti-symmetric filters, the center tap coefficient, COEFFICIENT(:,COEFFICIENT'high(2)) must be zero, but the redundant DSPx8 is removed
          C_LOW:INTEGER:=-17;
          ROUNDING:BOOLEAN:=FALSE;
          ANTI:BOOLEAN:=FALSE;        -- If even or odd symmetric, is it anti-symmetric?
          SYMMETRY:STRING:="ES";      -- Filter Symmetry, use "ES" for Even-Symmetric, "OS" for Odd-Symmetric and "NS" for Non-Symmetric
          FIRST_CHAIN: BOOLEAN := TRUE);
  port(CLK:in STD_LOGIC;
       CLKH:in STD_LOGIC:='0';        -- if DDR=FALSE can be left unconnected
       DI,BI:in SFIXED;               -- for non-symmetric filters use DI as input, tie BI to zero, for symmetric filters tie DI is forward data and BI is reverse data
       CI:in SFIXED;                  -- C input into the last DSPx8 in the chain, used for cascading transpose sections
       VI:in BOOLEAN:=TRUE;
       CEBI,CECI,CEDI:in BOOLEAN:=TRUE;
       CSA:in UNSIGNED:="0";          -- Coefficient Set Address, CSA'length must be equal to LOG2(COEFFICIENT'length(1))
       DO,BO:out SFIXED;              -- these are not used unless you build a systolic transposed filter structure
       O:out SFIXED;
       VO:out BOOLEAN);
end TRANSPOSE_SSR_FIR_CHAIN;

architecture TEST of TRANSPOSE_SSR_FIR_CHAIN is
  constant COEFFICIENT_SETS:INTEGER:=COEFFICIENT'length;
  constant TAPS:INTEGER:=COEFFICIENT(COEFFICIENT'low)'length;
  constant JLOW:INTEGER:=0;

  -- P/C signal width (must not exceed DSP P register width of 48/58 bits)
  constant P_HIGH : INTEGER := MAX(LOG2(TAPS)+BI'high+C_HIGH+1, O'high);
  constant P_LOW  : INTEGER := BI'low+C_LOW;

  -- -------------------------------------------------------------------------
  -- Helper functions
  -- -------------------------------------------------------------------------
  function BREG(SYMMETRY:STRING;ANTI:BOOLEAN;J:INTEGER) return INTEGER is
  begin
    if (SYMMETRY="ES") or (SYMMETRY="OS") then
      if (SYMMETRY="OS") and FIRST_CHAIN and J=JLOW then
        return 1;
      elsif (SYMMETRY/="OS") and J=JLOW then
        return 1;
      else
        return 2;
      end if;
    elsif SYMMETRY="NS" then
      return 1;
    else
      assert FALSE report "SYMMETRY must be either ""ES"", ""OS"" or ""NS""!" severity warning;
      return 0;
    end if;
  end;

  function LATENCY(SYMMETRY:STRING;TAPS:INTEGER) return INTEGER is
  begin
    if SYMMETRY="ES" then
      return 4;
    elsif SYMMETRY="OS" then
      return 4;
    elsif SYMMETRY="NS" then
      return 3;
    else
      assert FALSE report "SYMMETRY must be either ""ES"", ""OS"" or ""NS""!" severity warning;
      return 0;
    end if;
  end;

  function B_INPUT(J:INTEGER) return STRING is
  begin
    if J=JLOW then
      return "DIRECT";
    else
      return "CASCADE";
    end if;
  end;

  -- -------------------------------------------------------------------------
  -- Cascade signal arrays (one entry per DSP stage, plus boundary values)
  -- -------------------------------------------------------------------------
  type BC_VECTOR is array(INTEGER range <>) of STD_LOGIC_VECTOR(FAMILY/3*6+17 downto 0);
  type CS_VECTOR is array(INTEGER range <>) of UNSIGNED(LOG2(COEFFICIENT_SETS)-1 downto 0);
  type PC_VECTOR is array(INTEGER range <>) of STD_LOGIC_VECTOR(FAMILY/3*10+47 downto 0);
  subtype A_VECTOR is SFIXED_VECTOR(0 to COEFFICIENT'length-1)(C_HIGH downto C_LOW);

  signal BC : BC_VECTOR(JLOW to TAPS);
  signal PC : PC_VECTOR(JLOW to TAPS);

  -- -------------------------------------------------------------------------
  -- Per-stage coefficient ROM: AV_ALL(J)(coeff_set) = coefficient at tap J
  -- ALL_AV_INIT uses a local for-loop variable (not a generate variable) so J
  -- evaluates correctly for every iteration -> no xsim bug here.
  -- -------------------------------------------------------------------------
  function A_VALUE(COEFFICIENT:REAL_MATRIX;J:INTEGER) return A_VECTOR is
    variable AV:A_VECTOR;
  begin
    for K in AV'range loop
      AV(K):=TO_SFIXED(COEFFICIENT(COEFFICIENT'low+K)(COEFFICIENT(COEFFICIENT'low)'low+J),C_HIGH,C_LOW);
    end loop;
    return AV;
  end;

  type AV_MATRIX_T is array(INTEGER range <>) of A_VECTOR;

  function ALL_AV_INIT(COEFFICIENT:REAL_MATRIX) return AV_MATRIX_T is
    variable result : AV_MATRIX_T(JLOW to TAPS-1);
  begin
    for J in JLOW to TAPS-1 loop
      result(J) := A_VALUE(COEFFICIENT, TAPS-1-J); -- transposed FIR: tap 0 at last DSP
    end loop;
    return result;
  end;
  -- Elaboration-time constant: correct coefficient per stage, all coeff sets
  constant AV_ALL : AV_MATRIX_T(JLOW to TAPS-1) := ALL_AV_INIT(COEFFICIENT);

  -- -------------------------------------------------------------------------
  -- Static per-stage control arrays (constants, correct at elaboration time)
  -- -------------------------------------------------------------------------
  type OPMODE_ARR_T is array(INTEGER range <>) of STD_LOGIC_VECTOR(8 downto 0);
  type INMODE_ARR_T is array(INTEGER range <>) of STD_LOGIC_VECTOR(4 downto 0);

  function ALL_OPMODE_INIT return OPMODE_ARR_T is
    variable result : OPMODE_ARR_T(JLOW to TAPS-1);
  begin
    for J in JLOW to TAPS-1 loop
      if J = JLOW then
        result(J) := 9x"035";  -- first: P = C + A*D  (no PCIN cascade in)
      elsif J = TAPS-1 then
        result(J) := 9x"195";  -- last:  P = C + PCIN + A*D (CI passes via C)
      else
        result(J) := 9x"015";  -- middle: P = PCIN + A*D
      end if;
    end loop;
    return result;
  end;
  constant OPMODE_CONST : OPMODE_ARR_T(JLOW to TAPS-1) := ALL_OPMODE_INIT;

  function ALL_INMODE_INIT return INMODE_ARR_T is
    variable result : INMODE_ARR_T(JLOW to TAPS-1);
  begin
    for J in JLOW to TAPS-1 loop
      if SYMMETRY = "NS" then
        result(J) := 5x"07";  -- A1*D  (NS: no pre-adder subtraction)
      elsif ANTI and not ((SYMMETRY="OS") and FIRST_CHAIN and (J=JLOW)) then
        result(J) := 5x"0D";  -- A1*(D-B2)  (anti-symmetric)
      else
        result(J) := 5x"05";  -- A1*(D+B2)  (symmetric)
      end if;
    end loop;
    return result;
  end;
  constant INMODE_CONST : INMODE_ARR_T(JLOW to TAPS-1) := ALL_INMODE_INIT;

  -- -------------------------------------------------------------------------
  -- Architecture-level per-stage signal arrays
  -- Declared here (NOT inside for-generate) so each array element has exactly
  -- ONE driver -> no xsim signal-sharing / multiple-driver X propagation.
  -- -------------------------------------------------------------------------
  signal A_ARR : SFIXED_VECTOR(JLOW to TAPS-1)(C_HIGH downto C_LOW);
  signal B_ARR : SFIXED_VECTOR(JLOW to TAPS-1)(BI'high downto BI'low);
  signal C_ARR : SFIXED_VECTOR(JLOW to TAPS-1)(P_HIGH downto P_LOW);
  signal P_ARR : SFIXED_VECTOR(JLOW to TAPS-1)(P_HIGH downto P_LOW);
  signal CE_SIG, CEB1_SIG, CEC_SIG, CED_SIG : STD_LOGIC;

begin
  assert CSA'length=MAX(LOG2(COEFFICIENT'length(1)),1) report "Inconsistent CSA length!" severity warning;

  -- Cascade boundary initial values (tie chain input to zero)
  BC(JLOW) <= STD_LOGIC_VECTOR(TO_SIGNED(0,BC(JLOW)'length));
  PC(JLOW) <= STD_LOGIC_VECTOR(TO_SIGNED(0,PC(JLOW)'length));

  -- Clock enable signals (same for all DSP stages)
  CE_SIG   <= '1' when VI   else '0';
  CEB1_SIG <= '1' when CEBI else '0';
  CEC_SIG  <= '1' when CECI else '0';
  CED_SIG  <= '1' when CEDI else '0';

  -- A_ARR: select per-stage coefficient from the elaboration-time constant AV_ALL.
  -- Single process owns all elements; no for-generate concurrent-assignment bug.
  ia: if CSA'length=1 generate
    -- Combinatorial select (single coeff set or runtime-selected with 1-bit CSA).
    -- Explicit sensitivity list instead of process(all): xsim 2025.2 may not
    -- auto-detect SFIXED/UNSIGNED ports read through composite array indexing.
    process(CSA) begin
      for J in JLOW to TAPS-1 loop
        A_ARR(J) <= AV_ALL(J)(TO_INTEGER(CSA));
      end loop;
    end process;
  else generate
    -- Registered select: pipeline CSA through one CLK stage
    process(CLK) begin
      if rising_edge(CLK) then
        for J in JLOW to TAPS-1 loop
          A_ARR(J) <= AV_ALL(J)(TO_INTEGER(CSA));
        end loop;
      end if;
    end process;
  end generate;

  -- B_ARR: first stage and all NS stages get BI; remainder get 0.
  -- Explicit sensitivity list: xsim may not auto-detect BI (SFIXED port) via process(all).
  gen_b: process(BI) begin
    for J in JLOW to TAPS-1 loop
      if (J = JLOW) or (SYMMETRY = "NS") then
        B_ARR(J) <= BI;
      else
        B_ARR(J) <= (others => '0');
      end if;
    end loop;
  end process;

  -- C_ARR: rounding constant at first stage, RESIZE(CI) at last, 0 elsewhere.
  -- Explicit sensitivity list: xsim may not auto-detect CI (SFIXED port) via process(all),
  -- which would cause C_ARR(TAPS-1) to be stuck at 0, breaking the inter-chain cascade.
  gen_c: process(CI) begin
    for J in JLOW to TAPS-1 loop
      if ROUNDING and (J = JLOW) then
        C_ARR(J) <= TO_SFIXED(2.0**(P_LOW+O'low-1), P_HIGH, P_LOW);
      elsif J = TAPS-1 then
        C_ARR(J) <= RESIZE(CI, P_HIGH, P_LOW);
      else
        C_ARR(J) <= TO_SFIXED(0.0, P_HIGH, P_LOW);
      end if;
    end loop;
  end process;

  -- Output: last DSP stage P register
  O <= RESIZE(P_ARR(TAPS-1), O);

  -- -------------------------------------------------------------------------
  -- DSP cascade for-generate.
  -- ONLY entity instantiations appear here; xsim evaluates entity port maps
  -- correctly for every for-generate iteration so J-indexed signal accesses
  -- (A_ARR(J), B_ARR(J), BC(J), PC(J), etc.) connect to the right elements.
  -- Generic map expressions using J (BREG, B_INPUT, Y offset) also evaluate
  -- correctly since generics are set at elaboration time.
  -- -------------------------------------------------------------------------
  lj: for J in JLOW to TAPS-1 generate
    jk: entity work.DSPx8_WRAPPER
            generic map(X        => OX,
                        Y        => OY+J-JLOW,
                        FAMILY   => FAMILY,
                        BREG     => BREG(SYMMETRY,ANTI,J),
                        BCASCREG => BREG(SYMMETRY,ANTI,J),
                        B_INPUT  => B_INPUT(J),
                        PREADDINSEL => "B",
                        AMULTSEL    => "A",
                        BMULTSEL    => "AD")
            port map(CLK   => CLK,
                     CEB1  => CEB1_SIG,
                     CEB2  => CE_SIG,
                     CEC   => CEC_SIG,
                     CED   => CED_SIG,
                     A     => A_ARR(J),
                     B     => B_ARR(J),
                     C     => C_ARR(J),
                     D     => DI,
                     BCIN  => BC(J),
                     INMODE => INMODE_CONST(J),
                     OPMODE => OPMODE_CONST(J),
                     PCIN  => PC(J),
                     BCOUT => BC(J+1),
                     PCOUT => PC(J+1),
                     P     => P_ARR(J));
  end generate lj;

  -- DO: forward-data pipeline register (used when cascading chain sections)
  process(CLK)
  begin
    if rising_edge(CLK) then
      DO <= DI;
    end if;
  end process;

  -- BO: reverse-data shift register for cascading symmetric-filter sections
  db: entity work.SDELAY generic map(SIZE => 2*TAPS+BREG(SYMMETRY,ANTI,0)-1,
                                     DDR  => DDR)
                         port map(CLK  => CLK,
                                  CLKH => CLKH,
                                  I    => BI,
                                  O    => BO);

  -- Data Valid Delay Line
  bd: entity work.BDELAY generic map(SIZE => LATENCY(SYMMETRY,TAPS),
                                     DDR  => DDR)
                         port map(CLK  => CLK,
                                  CLKH => CLKH,
                                  I    => VI,
                                  O    => VO);

end TEST;
