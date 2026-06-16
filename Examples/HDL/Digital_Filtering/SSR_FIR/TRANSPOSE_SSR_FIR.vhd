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
-- TRANSPOSE_SSR_FIR_ROW
-- One J-row sub-filter for the transpose-form SSR FIR.  Instantiated SSR times
-- from TRANSPOSE_SSR_FIR via for-generate.  Keeping J as a generic constant
-- (not a for-generate loop variable) works around an xsim VHDL-2008 bug where
-- concurrent signal assignments and processes inside for-generate use only the
-- first iteration value of the loop parameter.  Entity instantiation port maps
-- are evaluated correctly for every iteration, so the row is instantiated with
-- the right J_IDX via the outer generate and handles its own K-loop internally.
-- =============================================================================
entity TRANSPOSE_SSR_FIR_ROW is
  generic(J_IDX:INTEGER;               -- row index (0..SSR-1)
          OX,OY:INTEGER;               -- floorplan origin; chains add K to OX
          FAMILY:INTEGER;
          DDR:BOOLEAN;
          COEFFICIENT:REAL_MATRIX;     -- full coefficient matrix; GET() selects K-slice
          TAPS_G:INTEGER;              -- total number of taps (passed in to size C)
          C_HIGH:INTEGER;
          C_LOW:INTEGER;
          EXTRA_C_PIPELINING:BOOLEAN;
          EXTRA_D_PIPELINING:BOOLEAN;
          ROUNDING:BOOLEAN;
          ANTI:BOOLEAN;
          SYMMETRY:STRING);
  port(CLK:in STD_LOGIC;
       CLKH:in STD_LOGIC;
       I:in SFIXED_VECTOR;             -- full SSR-wide input
       VI:in BOOLEAN;
       CSA:in UNSIGNED;                -- coefficient set address
       O_J:out SFIXED);               -- single sub-filter output (one lane)
end TRANSPOSE_SSR_FIR_ROW;

architecture ROW of TRANSPOSE_SSR_FIR_ROW is
  constant SSR:INTEGER:=I'length;
  constant D_HIGH:INTEGER:=I(I'low)'high;
  constant D_LOW :INTEGER:=I(I'low)'low;
  constant CH:INTEGER:=LOG2(TAPS_G)+D_HIGH+C_HIGH+2;
  constant CL:INTEGER:=D_LOW+C_LOW;
  -- All signals at architecture level - no for-generate local signal declarations.
  -- K-indexed signals are 1-D arrays (SFIXED_VECTOR or UNSIGNED_VECTOR), indexed
  -- by the lk for-generate parameter K.  J_IDX is a generic constant here, so
  -- every expression that references it is correctly evaluated in all contexts.
  signal C  :SFIXED_VECTOR(0 to SSR)(CH downto CL);
  signal ID,RD:SFIXED_VECTOR(I'range)(D_HIGH downto D_LOW);
  signal CP_K:SFIXED_VECTOR(0 to SSR-1)(CH downto CL)
              :=(others=>(others=>'0'));
  signal DD_K,BB_K:SFIXED_VECTOR(0 to SSR-1)(D_HIGH downto D_LOW)
                   :=(others=>(others=>'0'));
  signal DO_K,BO_K:SFIXED_VECTOR(0 to SSR-1)(D_HIGH downto D_LOW);
  signal CS:UNSIGNED_VECTOR(0 to SSR)(CSA'range):=(others=>(others=>'0'));

  function GET(COEFFICIENT:REAL_MATRIX;K:INTEGER) return REAL_MATRIX is
    constant TAPS_K:INTEGER:=COEFFICIENT(COEFFICIENT'low)'length;
    variable RESULT:REAL_MATRIX(COEFFICIENT'range)(0 to (TAPS_K+SSR-1)/SSR-1);
  begin
     for J in RESULT'range loop
        for L in RESULT(J)'range loop
           if SSR*L+SSR-1-K >= TAPS_K then
              RESULT(J)(L):=0.0;
           elsif (SYMMETRY="OS") and (SSR*L+SSR-1-K=TAPS_K-1) then
              RESULT(J)(L):=COEFFICIENT(J)(SSR*L+SSR-1-K)/2.0;
           else
              RESULT(J)(L):=COEFFICIENT(J)(SSR*L+SSR-1-K);
           end if;
        end loop;
     end loop;
     return RESULT;
  end;

begin
  C(0)<=TO_SFIXED(0.0,C(0));

  -- Anti+OS: center coefficient (last element of coefficient array) must be 0.0.
  -- The GET() function applies /2.0 to the center tap; for anti-symmetric filters
  -- the center must be zero so the pre-adder subtraction (D-B) cancels correctly.
  assert not (ANTI and SYMMETRY="OS" and
              COEFFICIENT(COEFFICIENT'low)(COEFFICIENT(COEFFICIENT'low)'high) /= 0.0)
    report "TRANSPOSE_SSR_FIR_ROW: ANTI+OS center coefficient must be 0.0"
    severity FAILURE;

  -- CS cascade: one process owns ALL elements of CS (including CS(0)) to avoid
  -- any cross-driver conflict on the unresolved UNSIGNED_VECTOR composite signal.
  -- Having CS(0)<=CSA as a separate concurrent assignment plus a process driving
  -- CS(1..SSR) makes xsim see the composite as having two drivers and CS(0) gets
  -- stuck at its initial value.  Absorbing CS(0)<=CSA into the same process (with
  -- CSA in the sensitivity list so it stays combinatorial) resolves this.
  cs_cascade:if EXTRA_C_PIPELINING generate
    process(CLK, CSA) begin
      CS(0)<=CSA;            -- combinatorial: all CSA changes reflected immediately
      if rising_edge(CLK) then
        CS(1)<=CSA;          -- CS(1) registered once from CSA
        for K in 1 to SSR-1 loop
          CS(K+1)<=CS(K);
        end loop;
      end if;
    end process;
  else generate
    process(all) begin
      CS(0)<=CSA;
      CS(1)<=CSA;
      for K in 1 to SSR-1 loop
        CS(K+1)<=CS(K);
      end loop;
    end process;
  end generate;

  -- CP_K cascade: one process owns ALL elements of CP_K to avoid any
  -- cross-driver conflict on the unresolved SFIXED_VECTOR composite signal.
  -- CP_K(0)=C(0)=0 always; CP_K(1..SSR-1) registered when EXTRA_C_PIPELINING.
  cp_cascade:if EXTRA_C_PIPELINING generate
    process(CLK) begin
      if rising_edge(CLK) then
        for K in 0 to SSR-1 loop
          CP_K(K)<=C(K);
        end loop;
      end if;
    end process;
  else generate
    process(all) begin
      for K in 0 to SSR-1 loop
        CP_K(K)<=C(K);
      end loop;
    end process;
  end generate;

  -- DD_K / BB_K: registered when EXTRA_D_PIPELINING, wired otherwise.
  -- Single process drives all SSR elements to avoid multiple-driver issues.
  dd_bb_pipe:if EXTRA_D_PIPELINING generate
    process(CLK) begin
      if rising_edge(CLK) then
        for K in 0 to SSR-1 loop
          DD_K(K)<=ID(K+I'low);
          BB_K(K)<=RD(K+I'low);
        end loop;
      end if;
    end process;
  else generate
    process(all) begin
      for K in 0 to SSR-1 loop
        DD_K(K)<=ID(K+I'low);
        BB_K(K)<=RD(K+I'low);
      end loop;
    end process;
  end generate;

  -- RD for NS symmetry: no reverse-input path, drive entire array to zero.
  -- Handled here at architecture level (not inside the lk for-generate) so
  -- there is exactly one driver on the unresolved SFIXED_VECTOR signal.
  rd_ns:if SYMMETRY="NS" generate
    RD<=(others=>(others=>'0'));
  end generate;

  -- K-loop: ONLY entity instantiations appear here.
  -- Concurrent signal assignments and processes have been moved to architecture-level
  -- constructs above so xsim's for-generate multiple-driver bug cannot affect them.
  lk:for K in 0 to SSR-1 generate

    -- Triangular input delay: selects and time-aligns the correct input sample
    -- for this (J_IDX, K) filter chain.  J_IDX is a generic constant so the
    -- SIZE expression is evaluated correctly for each elaborated ROW instance.
    sd_gen:if J_IDX=(SSR-1) generate
             sd:entity work.SDELAY
                   generic map(SIZE=>2*K+K*BOOLEAN'pos(EXTRA_C_PIPELINING),
                               DDR=>DDR)
                   port map(CLK=>CLK,
                            CLKH=>CLKH,
                            I=>I((1+K+J_IDX) mod SSR+I'low),
                            O=>ID(K+I'low));
           else generate
             sd:entity work.SDELAY
                   generic map(SIZE=>1+2*K-(J_IDX+K)/(SSR-1)+K*BOOLEAN'pos(EXTRA_C_PIPELINING),
                               DDR=>DDR)
                   port map(CLK=>CLK,
                            CLKH=>CLKH,
                            I=>I((1+K+J_IDX) mod SSR+I'low),
                            O=>ID(K+I'low));
           end generate;

    -- Reverse input delay for symmetric path (ES/OS only).
    -- NS symmetry: RD is driven to zero at architecture level above.
    ri:if SYMMETRY="ES" generate
         dr_gen:if J_IDX=(SSR-1) generate
                  dr:entity work.SDELAY
                        generic map(SIZE=>2*(SSR-K)-1+(SSR-K-1)*BOOLEAN'pos(EXTRA_C_PIPELINING),
                                    DDR=>DDR)
                        port map(CLK=>CLK,
                                 CLKH=>CLKH,
                                 I=>I((1+J_IDX+K) mod SSR+I'low),
                                 O=>RD(SSR-1-K+I'low));
                else generate
                  dr:entity work.SDELAY
                        generic map(SIZE=>1+2*(SSR-K)-1-(J_IDX+K)/(SSR-1)+(SSR-K-1)*BOOLEAN'pos(EXTRA_C_PIPELINING),
                                    DDR=>DDR)
                        port map(CLK=>CLK,
                                 CLKH=>CLKH,
                                 I=>I((1+J_IDX+K) mod SSR+I'low),
                                 O=>RD(SSR-1-K+I'low));
                end generate;
       elsif SYMMETRY="OS" generate
         dr:entity work.SDELAY
               generic map(SIZE=>2*(SSR-K-1)+BOOLEAN'pos(((J_IDX+K+2) mod SSR)>J_IDX)+(SSR-K-1)*BOOLEAN'pos(EXTRA_C_PIPELINING),
                           DDR=>DDR)
               port map(CLK=>CLK,
                        CLKH=>CLKH,
                        I=>I((J_IDX+K+2) mod SSR+I'low),
                        O=>RD(SSR-1-K+I'low));
       end generate;

    -- Accumulator chain for this (J_IDX, K) tap group.
    jk:entity work.TRANSPOSE_SSR_FIR_CHAIN
            generic map(OX=>OX+K,
                        OY=>OY,
                        FAMILY=>FAMILY,
                        DDR=>DDR,
                        COEFFICIENT=>GET(COEFFICIENT,K),
                        C_HIGH=>C_HIGH,
                        C_LOW=>C_LOW,
                        ROUNDING=>ROUNDING and (K=0),
                        ANTI=>ANTI,
                        SYMMETRY=>SYMMETRY,
                        FIRST_CHAIN=>K=0)
            port map(CLK=>CLK,
                     CLKH=>CLKH,
                     DI=>DD_K(K),
                     BI=>BB_K(K),
                     CI=>CP_K(K),
                     VI=>VI,
                     CSA=>CS(K),
                     DO=>DO_K(K),
                     BO=>BO_K(K),
                     O=>C(K+1),
                     VO=>open);
  end generate lk;

  O_J<=RESIZE(C(SSR),O_J);

end ROW;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.FIXED_PKG.all;
use work.CFIXED_PKG.all;

-- =============================================================================
-- TRANSPOSE_SSR_FIR
-- Top-level SSR polyphase transpose-form FIR filter.
-- Instantiates SSR TRANSPOSE_SSR_FIR_ROW entities via a for-generate.
-- Only entity instantiations appear inside the for-generate (no concurrent
-- signal assignments or processes) so xsim's for-generate evaluation bug does
-- not affect correctness.  J is passed as a generic constant J_IDX to each row.
-- =============================================================================
entity TRANSPOSE_SSR_FIR is
  generic(OX,OY:INTEGER:=-2147483648; -- Coordinates of the lower left corner DSPx8, use -2147483648 if you do not want floorplanning
          FAMILY:INTEGER:=3;          -- use 1 for 7-series, 2 for US/US+ and 3 for Versal
          DDR:BOOLEAN:=FALSE;         -- DDR implementation to be used only for Versal -3 and clock rates over 872MHz
          COEFFICIENT:REAL_MATRIX;    -- Number of Coefficient Sets=COEFFICIENT'length(1), Number of Taps=COEFFICIENT'length(2)
          C_HIGH:INTEGER:=0;          -- For odd anti-symmetric filters, the center tap coefficient, COEFFICIENT(:,COEFFICIENT'high(2)) must be zero, but the redundant DSPx8 is removed
          C_LOW:INTEGER:=-17;
          EXTRA_C_PIPELINING:BOOLEAN:=TRUE;
          EXTRA_D_PIPELINING:BOOLEAN:=TRUE;
          ROUNDING:BOOLEAN:=FALSE;
          ANTI:BOOLEAN:=FALSE;        -- If even or odd symmetric, is it anti-symmetric?
          SYMMETRY:STRING:="ES");     -- Filter Symmetry, use "ES" for Even-Symmetric, "OS" for Odd-Symmetric and "NS" for Non-Symmetric
  port(CLK:in STD_LOGIC;
       CLKH:in STD_LOGIC:='0';        -- if DDR=FALSE can be left unconnected
       I:in SFIXED_VECTOR;            -- for non-symmetric filters use DI as input, tie BI to zero, for symmetric filters tie DI and BI together
       VI:in BOOLEAN:=TRUE;           -- WARNING: VI must not be deasserted mid-stream.
                                      -- SDELAY chains are not gated by VI; deasserting VI
                                      -- after data has entered the pipeline causes permanent
                                      -- misalignment between the data path and VO delay line.
                                      -- There is no reset port — power-cycle to recover.
       --CEBI,CECI,CEDI:in BOOLEAN:=TRUE;
       CSA:in UNSIGNED:="0";          -- Coefficient Set Address, CSA'length must be equal to LOG2(COEFFICIENT'length(1))
       O:out SFIXED_VECTOR;
       VO:out BOOLEAN);
end TRANSPOSE_SSR_FIR;

architecture TEST of TRANSPOSE_SSR_FIR is
  constant COEFFICIENT_SETS:INTEGER:=COEFFICIENT'length;
  constant TAPS:INTEGER:=COEFFICIENT(COEFFICIENT'low)'length;
  constant SSR:INTEGER:=I'length;
  -- DSP port widths (integer division intentional; matches DSPx8_WRAPPER slv* signals)
  constant I_WIDTH  :INTEGER:=I(I'low)'high-I(I'low)'low+1; -- data bit width
  constant C_WIDTH  :INTEGER:=C_HIGH-C_LOW+1;               -- coefficient bit width
  constant A_PORT_W :INTEGER:=FAMILY/3*4+30;  -- A port: 34b Versal/DSP58, 30b US+/DSP48E2
  constant D_PORT_W :INTEGER:=27;             -- D port: 27b on all families (FAMILY/2*2+25)
  constant B_PORT_W :INTEGER:=FAMILY/3*6+18;  -- B port: 24b Versal/DSP58, 18b US+/DSP48E2
begin
  assert I'length=O'length report "Inconsistent I and O port lengths!" severity warning;
  assert CSA'length=MAX(LOG2(COEFFICIENT'length(1)),1) report "Inconsistent CSA length!" severity warning;
  -- DSP port truncation guards -------------------------------------------
  -- Coefficient maps to DSP A port (AMULTSEL="A", PREADDINSEL="B").
  -- Exceeding A_PORT_W silently truncates coefficient MSBs -> wrong MAC results.
  assert C_WIDTH<=A_PORT_W
    report "TRANSPOSE_SSR_FIR: coefficient width "&INTEGER'image(C_WIDTH)
          &"b exceeds DSP A port ("&INTEGER'image(A_PORT_W)
          &"b on FAMILY="&INTEGER'image(FAMILY)
          &") - reduce C_HIGH-C_LOW or target FAMILY=3 (Versal, A=34b)"
    severity FAILURE;
  -- Forward data maps to DSP D port (always, all filter modes; BMULTSEL="AD", B=0 for NS).
  -- D port is 27b on all supported families.  Exceeding it truncates data MSBs.
  assert I_WIDTH<=D_PORT_W
    report "TRANSPOSE_SSR_FIR: data width "&INTEGER'image(I_WIDTH)
          &"b exceeds DSP D port (27b, all families) - reduce I_HIGH-I_LOW"
    severity FAILURE;
  -- Reverse data maps to DSP B port (ES/OS only; B is forced to 0 for NS so no risk).
  -- B port is narrower than D: 24b Versal, 18b US+.  Exceeding it truncates the
  -- reverse pre-adder operand -> wrong ES/OS symmetric filter output.
  assert SYMMETRY="NS" or I_WIDTH<=B_PORT_W
    report "TRANSPOSE_SSR_FIR: data width "&INTEGER'image(I_WIDTH)
          &"b exceeds DSP B port ("&INTEGER'image(B_PORT_W)
          &"b on FAMILY="&INTEGER'image(FAMILY)&") for "&SYMMETRY
          &" reverse path - reduce I_HIGH-I_LOW"
          &" or switch to FAMILY=3 (Versal, B=24b vs US+ B=18b)"
    severity FAILURE;
  -- -----------------------------------------------------------------------

  -- Instantiate one row sub-filter per SSR lane.  Only entity instantiations
  -- appear inside this for-generate so xsim evaluates J correctly for all
  -- J=0..SSR-1 (xsim correctly handles for-generate for entity port maps).
  lj:for J in SSR-1 downto 0 generate
    jrow:entity work.TRANSPOSE_SSR_FIR_ROW
           generic map(J_IDX              => J,
                       OX                 => OX,
                       OY                 => OY+TAPS/SSR*J,
                       FAMILY             => FAMILY,
                       DDR                => DDR,
                       COEFFICIENT        => COEFFICIENT,
                       TAPS_G             => TAPS,
                       C_HIGH             => C_HIGH,
                       C_LOW              => C_LOW,
                       EXTRA_C_PIPELINING => EXTRA_C_PIPELINING,
                       EXTRA_D_PIPELINING => EXTRA_D_PIPELINING,
                       ROUNDING           => ROUNDING,
                       ANTI               => ANTI,
                       SYMMETRY           => SYMMETRY)
           port map(CLK  => CLK,
                    CLKH => CLKH,
                    I    => I,
                    VI   => VI,
                    CSA  => CSA,
                    O_J  => O(J+O'low));
  end generate lj;

-- Data Valid Delay Line
-- Latency formula (EXTRA_C=TRUE, EXTRA_D=TRUE): 2*SSR + 2 + (SSR-1) + 1 = 3*SSR + 2
-- SSR LATENCY
--  1   5
--  2   8
--  3  11
--  4  14
--  5  17
--  6  20
--  8  26
-- 10  32
  bd:entity work.BDELAY generic map(SIZE=>2*SSR+2+(SSR-1)*BOOLEAN'pos(EXTRA_C_PIPELINING)+BOOLEAN'pos(EXTRA_D_PIPELINING),
                                    DDR=>DDR)
                        port map(CLK=>CLK,
                                 CLKH=>CLKH,
                                 I=>VI,
                                 O=>VO);
end TEST;
