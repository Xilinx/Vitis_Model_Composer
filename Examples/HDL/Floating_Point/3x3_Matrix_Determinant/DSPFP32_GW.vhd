library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

use work.FLOAT_PKG.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity DSPFP32_GW is
  generic(X,Y:INTEGER:=-1000;
          ACASCREG:INTEGER:=1;                                       -- Number of pipeline stages between A/ACIN and ACOUT (0-2)
          AREG:INTEGER:=1;                                           -- Pipeline stages for A (0-2)
          A_FPTYPE:STRING:="B32";                                    -- B16, B32
          A_INPUT:STRING:="DIRECT";                                  -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
          BCASCSEL:STRING:="B";                                      -- Selects B cascade out data (B, D).
          B_D_FPTYPE:STRING:="B32";                                  -- B16, B32
          B_INPUT:STRING:="DIRECT";                                  -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
          FPA_PREG:INTEGER:=1;                                       -- Pipeline stages for FPA output (0-1)
          FPBREG:INTEGER:=1;                                         -- Pipeline stages for B inputs (0-1)
          FPCREG:INTEGER:=3;                                         -- Pipeline stages for C input (0-3)
          FPDREG:INTEGER:=1;                                         -- Pipeline stages for D inputs (0-1)
          FPMPIPEREG:INTEGER:=1;                                     -- Selects the number of FPMPIPE registers (0-1)
          FPM_PREG:INTEGER:=1;                                       -- Pipeline stages for FPM output (0-1)
          FPOPMREG:INTEGER:=3;                                       -- Selects the length of the FPOPMODE pipeline (0-3)
          INMODEREG:INTEGER:=1;                                      -- Selects the number of FPINMODE registers (0-1)
          IS_ASYNC_RST_INVERTED:BIT:='0';                            -- Optional inversion for AYNC_RST                                                                                                   
          IS_CLK_INVERTED:bit:='0';                                  -- Optional inversion for CLK                                                                        
          IS_FPINMODE_INVERTED:bit:='0';                             -- Optional inversion for FPINMODE                                                                        
          IS_FPOPMODE_INVERTED:STD_LOGIC_VECTOR(6 downto 0):=7x"00"; -- Optional inversion for FPOPMODE                                                                        
          IS_RSTA_INVERTED:bit:='0';                                 -- Optional inversion for RSTA                                                                        
          IS_RSTB_INVERTED:bit:='0';                                 -- Optional inversion for RSTB                                                                        
          IS_RSTC_INVERTED:bit:='0';                                 -- Optional inversion for RSTC                                                                        
          IS_RSTD_INVERTED:bit:='0';                                 -- Optional inversion for RSTD                                                                        
          IS_RSTFPA_INVERTED:bit:='0';                               -- Optional inversion for RSTFPA                                                                        
          IS_RSTFPINMODE_INVERTED:bit:='0';                          -- Optional inversion for RSTFPINMODE                                                                        
          IS_RSTFPMPIPE_INVERTED:bit:='0';                           -- Optional inversion for RSTFPMPIPE                                                                        
          IS_RSTFPM_INVERTED:bit:='0';                               -- Optional inversion for RSTFPM                                                                        
          IS_RSTFPOPMODE_INVERTED:bit:='0';                          -- Optional inversion for RSTFPOPMODE                           
          PCOUTSEL:STRING:="FPA";                                    -- Select PCOUT output cascade of DSPFP32 (FPA, FPM)
          RESET_MODE:STRING:="SYNC";                                 -- Selection of synchronous or asynchronous reset. (ASYNC, SYNC).
          USE_MULT:STRING:="MULTIPLY");                              -- Select multiplier usage (DYNAMIC, MULTIPLY, NONE)
  port(ACIN:in FLOAT32:=32x"00000000";                               -- 32-bit input: A cascade input
       ASYNC_RST:in STD_LOGIC:='0';                                  -- 1-bit input: Asynchronous reset for all registers.
       A:in FLOAT32:=32x"00000000";                                  -- 32-bit input: A input
       BCIN:in FLOAT32:=32x"00000000";                               -- 32-bit input: B cascade input
       B:in FLOAT32:=32x"00000000";                                  -- 32-bit input: B input
       C:in FLOAT32:=32x"00000000";                                  -- 32-bit input: C input
       CEA1:in STD_LOGIC:='1';                                       -- 1-bit input: Clock enable for 1st stage AREG
       CEA2:in STD_LOGIC:='1';                                       -- 1-bit input: Clock enable for 2nd stage AREG
       CEB:in STD_LOGIC:='1';                                        -- 1-bit input: Clock enable BREG
       CEC:in STD_LOGIC:='1';                                        -- 1-bit input: Clock enable for CREG
       CED:in STD_LOGIC:='1';                                        -- 1-bit input: Clock enable for DREG
       CEFPA:in STD_LOGIC:='1';                                      -- 1-bit input: Clock enable for FPA_PREG
       CEFPINMODE:in STD_LOGIC:='1';                                 -- 1-bit input: Clock enable for FPINMODE register
       CEFPM:in STD_LOGIC:='1';                                      -- 1-bit input: Clock enable for FPM output register.
       CEFPMPIPE:in STD_LOGIC:='1';                                  -- 1-bit input: Clock enable for FPMPIPE post multiplier register.
       CEFPOPMODE:in STD_LOGIC:='1';                                 -- 1-bit input: Clock enable for FPOPMODE post multiplier register.
       CLK:in STD_LOGIC;                                             -- 1-bit input: Clock
       D:in FLOAT32:=32x"00000000";                                  -- 32-bit input: D input
       FPINMODE:in STD_LOGIC:='1';                                   -- 1-bit input: Controls select for B/D input data mux.
       FPOPMODE:in STD_LOGIC_VECTOR(6 downto 0):=7x"00";             -- 7-bit input: Selects input signals to floating-point adder and input negation. 6543210
       PCIN:in FLOAT32:=32x"00000000";                               -- 32-bit input: P cascade input                                                  .....00 P0=0
       RSTA:in STD_LOGIC:='0';                                       -- 1-bit input: Reset for AREG                                                    .....01 P0=M
       RSTB:in STD_LOGIC:='0';                                       -- 1-bit input: Reset for BREG                                                    .....10 P0=PCIN
       RSTC:in STD_LOGIC:='0';                                       -- 1-bit input: Reset for CREG                                                    .....11 P0=D
       RSTD:in STD_LOGIC:='0';                                       -- 1-bit input: Reset for DREG                                                    ..0xx.. P1=0    
       RSTFPA:in STD_LOGIC:='0';                                     -- 1-bit input: Reset for FPA output register                                     ..10X.. P1=P
       RSTFPINMODE:in STD_LOGIC:='0';                                -- 1-bit input: Reset for FPINMODE register                                       ..110.. P1=C
       RSTFPM:in STD_LOGIC:='0';                                     -- 1-bit input: Reset for FPM output register                                     ..111.. P1=PCIN 
       RSTFPMPIPE:in STD_LOGIC:='0';                                 -- 1-bit input: Reset for FPMPIPE register                                        00..... FPA_OUT=P0+P1
       RSTFPOPMODE:in STD_LOGIC:='0';                                -- 1-bit input: Reset for FPOPMODE registers                                      01..... FPA_OUT=-P0+P1
       ACOUT:out FLOAT32;                                            -- 32-bit A cascade output                                                        10..... FPA_OUT=P0-P1
       BCOUT:out FLOAT32;                                            -- 32-bit B cascade output                                                        11..... FPA_OUT=-P0-P1
       FPA_INVALID:out STD_LOGIC;                                    -- 1-bit output: Invalid flag for FPA output
       FPA_OUT:out FLOAT32;                                          -- 32-bit output: Adder/accumlator data output
       FPA_OVERFLOW:out STD_LOGIC;                                   -- 1-bit output: Overflow signal for adder/accumlator data output
       FPA_UNDERFLOW:out STD_LOGIC;                                  -- 1-bit output: Underflow signal for adder/accumlator data output
       FPM_INVALID:out STD_LOGIC;                                    -- 1-bit output: Invalid flag for FPM output
       FPM_OUT:out FLOAT32;                                          -- 32-bit output: Multiplier data output
       FPM_OVERFLOW:out STD_LOGIC;                                   -- 1-bit output: Overflow signal for multiplier data output
       FPM_UNDERFLOW:out STD_LOGIC;                                  -- 1-bit output: Underflow signal for multiplier data output
       PCOUT:out FLOAT32);                                           -- 32-bit output: P cascade output
  attribute secure_config:STRING;
  attribute secure_config of DSPFP32_GW:entity is "PROTECT";
end DSPFP32_GW;

architecture TEST of DSPFP32_GW is
  attribute keep_hierarchy:STRING;
  attribute keep_hierarchy of all:architecture is "yes";
  attribute syn_hier:STRING;
  attribute syn_hier of all:architecture is "hard";
  
  function TO_SLV(A:FLOAT32;H,L:INTEGER) return STD_LOGIC_VECTOR is
    variable R:STD_LOGIC_VECTOR(H-L downto 0);
  begin
    for K in R'range loop
      R(K):=A(K+L);
    end loop;
    return R;
  end;

  signal slvFPA_OUT,slvFPM_OUT:STD_LOGIC_VECTOR(31 downto 0);
  signal slvACOUT,slvBCOUT,slvPCOUT:STD_LOGIC_VECTOR(31 downto 0);
begin
  i0:if (X<0) or (Y<0) generate
       u1:DSPFP32 generic map(-- Feature Control Attributes: Data Path Selection
                              A_FPTYPE=>A_FPTYPE,                               -- B16, B32
                              A_INPUT=>A_INPUT,                                 -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
                              BCASCSEL=>BCASCSEL,                               -- Selects B cascade out data (B, D).
                              B_D_FPTYPE=>B_D_FPTYPE,                           -- B16, B32
                              B_INPUT=>B_INPUT,                                 -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
                              PCOUTSEL=>PCOUTSEL,                               -- Select PCOUT output cascade of DSPFP32 (FPA, FPM)
                              USE_MULT=>USE_MULT,                               -- Select multiplier usage (DYNAMIC, MULTIPLY, NONE)
                              -- Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
                              IS_ASYNC_RST_INVERTED=>IS_ASYNC_RST_INVERTED,     -- Optional inversion for AYNC_RST
                              IS_CLK_INVERTED=>IS_CLK_INVERTED,                 -- Optional inversion for CLK
                              IS_FPINMODE_INVERTED=>IS_FPINMODE_INVERTED,       -- Optional inversion for FPINMODE
                              IS_FPOPMODE_INVERTED=>IS_FPOPMODE_INVERTED,       -- Optional inversion for FPOPMODE
                              IS_RSTA_INVERTED=>IS_RSTA_INVERTED,               -- Optional inversion for RSTA
                              IS_RSTB_INVERTED=>IS_RSTB_INVERTED,               -- Optional inversion for RSTB
                              IS_RSTC_INVERTED=>IS_RSTC_INVERTED,               -- Optional inversion for RSTC
                              IS_RSTD_INVERTED=>IS_RSTD_INVERTED,               -- Optional inversion for RSTD
                              IS_RSTFPA_INVERTED=>IS_RSTFPA_INVERTED,           -- Optional inversion for RSTFPA
                              IS_RSTFPINMODE_INVERTED=>IS_RSTFPINMODE_INVERTED, -- Optional inversion for RSTFPINMODE
                              IS_RSTFPMPIPE_INVERTED=>IS_RSTFPMPIPE_INVERTED,   -- Optional inversion for RSTFPMPIPE
                              IS_RSTFPM_INVERTED=>IS_RSTFPM_INVERTED,           -- Optional inversion for RSTFPM
                              IS_RSTFPOPMODE_INVERTED=>IS_RSTFPOPMODE_INVERTED, -- Optional inversion for RSTFPOPMODE
                              -- Register Control Attributes: Pipeline Register Configuration
                              ACASCREG=>ACASCREG,                               -- Number of pipeline stages between A/ACIN and ACOUT (0-2)
                              AREG=>AREG,                                       -- Pipeline stages for A (0-2)
                              FPA_PREG=>FPA_PREG,                               -- Pipeline stages for FPA output (0-1)
                              FPBREG=>FPBREG,                                   -- Pipeline stages for B inputs (0-1)
                              FPCREG=>FPCREG,                                   -- Pipeline stages for C input (0-3)
                              FPDREG=>FPDREG,                                   -- Pipeline stages for D inputs (0-1)
                              FPMPIPEREG=>FPMPIPEREG,                           -- Selects the number of FPMPIPE registers (0-1)
                              FPM_PREG=>FPM_PREG,                               -- Pipeline stages for FPM output (0-1)
                              FPOPMREG=>FPOPMREG,                               -- Selects the length of the FPOPMODE pipeline (0-3)
                              INMODEREG=>INMODEREG,                             -- Selects the number of FPINMODE registers (0-1)
                              RESET_MODE=>RESET_MODE)                           -- Selection of synchronous or asynchronous reset. (ASYNC, SYNC).
                  port map(-- Cascade inputs: Cascade Ports
                           ACIN_EXP=>TO_SLV(ACIN,7,0),                          -- 8-bit input: A exponent cascade data
                           ACIN_MAN=>TO_SLV(ACIN,-1,-23),                       -- 23-bit input: A mantissa cascade data
                           ACIN_SIGN=>ACIN(8),                                  -- 1-bit input: A sign cascade data
                           BCIN_EXP=>TO_SLV(BCIN,7,0),                          -- 8-bit input: B exponent cascade data
                           BCIN_MAN=>TO_SLV(BCIN,-1,-23),                       -- 23-bit input: B mantissa cascade data
                           BCIN_SIGN=>BCIN(8),                                  -- 1-bit input: B sign cascade data
                           PCIN=>TO_SLV(PCIN,8,-23),                            -- 32-bit input: P cascade
                           -- Control inputs: Control Inputs/Status Bits
                           CLK=>CLK,                                            -- 1-bit input: Clock
                           FPINMODE=>FPINMODE,                                  -- 1-bit input: Controls select for B/D input data mux.
                           FPOPMODE=>FPOPMODE,                                  -- 7-bit input: Selects input signals to floating-point adder and input negation.
                           -- Data inputs: Data Ports
                           A_EXP=>TO_SLV(A,7,0),                                -- 8-bit input: A data exponent
                           A_MAN=>TO_SLV(A,-1,-23),                             -- 23-bit input: A data mantissa
                           A_SIGN=>A(8),                                        -- 1-bit input: A data sign bit
                           B_EXP=>TO_SLV(B,7,0),                                -- 8-bit input: B data exponent
                           B_MAN=>TO_SLV(B,-1,-23),                             -- 23-bit input: B data mantissa
                           B_SIGN=>B(8),                                        -- 1-bit input: B data sign bit
                           C=>TO_SLV(C,8,-23),                                  -- 32-bit input: C data input in Binary32 format.
                           D_EXP=>TO_SLV(D,7,0),                                -- 8-bit input: D data exponent
                           D_MAN=>TO_SLV(D,-1,-23),                             -- 23-bit input: D data mantissa
                           D_SIGN=>D(8),                                        -- 1-bit input: D data sign bit
                           -- Reset/Clock Enable inputs: Reset/Clock Enable Inputs
                           ASYNC_RST=>ASYNC_RST,                                -- 1-bit input: Asynchronous reset for all registers.
                           CEA1=>CEA1,                                          -- 1-bit input: Clock enable for 1st stage AREG
                           CEA2=>CEA2,                                          -- 1-bit input: Clock enable for 2nd stage AREG
                           CEB=>CEB,                                            -- 1-bit input: Clock enable BREG
                           CEC=>CEC,                                            -- 1-bit input: Clock enable for CREG
                           CED=>CED,                                            -- 1-bit input: Clock enable for DREG
                           CEFPA=>CEFPA,                                        -- 1-bit input: Clock enable for FPA_PREG
                           CEFPINMODE=>CEFPINMODE,                              -- 1-bit input: Clock enable for FPINMODE register
                           CEFPM=>CEFPM,                                        -- 1-bit input: Clock enable for FPM output register.
                           CEFPMPIPE=>CEFPMPIPE,                                -- 1-bit input: Clock enable for FPMPIPE post multiplier register.
                           CEFPOPMODE=>CEFPOPMODE,                              -- 1-bit input: Clock enable for FPOPMODE post multiplier register.
                           RSTA=>RSTA,                                          -- 1-bit input: Reset for AREG
                           RSTB=>RSTB,                                          -- 1-bit input: Reset for BREG
                           RSTC=>RSTC,                                          -- 1-bit input: Reset for CREG
                           RSTD=>RSTD,                                          -- 1-bit input: Reset for DREG
                           RSTFPA=>RSTFPA,                                      -- 1-bit input: Reset for FPA output register
                           RSTFPINMODE=>RSTFPINMODE,                            -- 1-bit input: Reset for FPINMODE register
                           RSTFPM=>RSTFPM,                                      -- 1-bit input: Reset for FPM output register
                           RSTFPMPIPE=>RSTFPMPIPE,                              -- 1-bit input: Reset for FPMPIPE register
                           RSTFPOPMODE=>RSTFPOPMODE,                            -- 1-bit input: Reset for FPOPMODE registers
                           -- Cascade outputs: Cascade Ports
                           ACOUT_EXP=>slvACOUT(30 downto 23),                   -- 8-bit output: A exponent cascade data
                           ACOUT_MAN=>slvACOUT(22 downto 0),                    -- 23-bit output: A mantissa cascade data
                           ACOUT_SIGN=>slvACOUT(31),                            -- 1-bit output: A sign cascade data
                           BCOUT_EXP=>slvBCOUT(30 downto 23),                   -- 8-bit output: B exponent cascade data
                           BCOUT_MAN=>slvBCOUT(22 downto 0),                    -- 23-bit output: B mantissa cascade data
                           BCOUT_SIGN=>slvBCOUT(31),                            -- 1-bit output: B sign cascade data
                           PCOUT=>slvPCOUT,                                     -- 32-bit output: Cascade output
                           -- Data outputs: Data Ports     
                           FPA_INVALID=>FPA_INVALID,                            -- 1-bit output: Invalid flag for FPA output
                           FPA_OUT=>slvFPA_OUT,                                 -- 32-bit output: Adder/accumlator data output in Binary32 format.
                           FPA_OVERFLOW=>FPA_OVERFLOW,                          -- 1-bit output: Overflow signal for adder/accumlator data output
                           FPA_UNDERFLOW=>FPA_UNDERFLOW,                        -- 1-bit output: Underflow signal for adder/accumlator data output
                           FPM_INVALID=>FPM_INVALID,                            -- 1-bit output: Invalid flag for FPM output
                           FPM_OUT=>slvFPM_OUT,                                 -- 32-bit output: Multiplier data output in Binary32 format.
                           FPM_OVERFLOW=>FPM_OVERFLOW,                          -- 1-bit output: Overflow signal for multiplier data output
                           FPM_UNDERFLOW=>FPM_UNDERFLOW);                       -- 1-bit output: Underflow signal for multiplier data output
     end generate;

  i1:if (X>=0) and (Y>=0) generate
       attribute loc:STRING;
       attribute loc of u1:label is "DSP_X"&INTEGER'image(X)&"Y"&INTEGER'image(Y);
     begin
       u1:DSPFP32 generic map(-- Feature Control Attributes: Data Path Selection
                              A_FPTYPE=>A_FPTYPE,                               -- B16, B32
                              A_INPUT=>A_INPUT,                                 -- Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
                              BCASCSEL=>BCASCSEL,                               -- Selects B cascade out data (B, D).
                              B_D_FPTYPE=>B_D_FPTYPE,                           -- B16, B32
                              B_INPUT=>B_INPUT,                                 -- Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
                              PCOUTSEL=>PCOUTSEL,                               -- Select PCOUT output cascade of DSPFP32 (FPA, FPM)
                              USE_MULT=>USE_MULT,                               -- Select multiplier usage (DYNAMIC, MULTIPLY, NONE)
                              -- Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
                              IS_ASYNC_RST_INVERTED=>IS_ASYNC_RST_INVERTED,     -- Optional inversion for AYNC_RST
                              IS_CLK_INVERTED=>IS_CLK_INVERTED,                 -- Optional inversion for CLK
                              IS_FPINMODE_INVERTED=>IS_FPINMODE_INVERTED,       -- Optional inversion for FPINMODE
                              IS_FPOPMODE_INVERTED=>IS_FPOPMODE_INVERTED,       -- Optional inversion for FPOPMODE
                              IS_RSTA_INVERTED=>IS_RSTA_INVERTED,               -- Optional inversion for RSTA
                              IS_RSTB_INVERTED=>IS_RSTB_INVERTED,               -- Optional inversion for RSTB
                              IS_RSTC_INVERTED=>IS_RSTC_INVERTED,               -- Optional inversion for RSTC
                              IS_RSTD_INVERTED=>IS_RSTD_INVERTED,               -- Optional inversion for RSTD
                              IS_RSTFPA_INVERTED=>IS_RSTFPA_INVERTED,           -- Optional inversion for RSTFPA
                              IS_RSTFPINMODE_INVERTED=>IS_RSTFPINMODE_INVERTED, -- Optional inversion for RSTFPINMODE
                              IS_RSTFPMPIPE_INVERTED=>IS_RSTFPMPIPE_INVERTED,   -- Optional inversion for RSTFPMPIPE
                              IS_RSTFPM_INVERTED=>IS_RSTFPM_INVERTED,           -- Optional inversion for RSTFPM
                              IS_RSTFPOPMODE_INVERTED=>IS_RSTFPOPMODE_INVERTED, -- Optional inversion for RSTFPOPMODE
                              -- Register Control Attributes: Pipeline Register Configuration
                              ACASCREG=>ACASCREG,                               -- Number of pipeline stages between A/ACIN and ACOUT (0-2)
                              AREG=>AREG,                                       -- Pipeline stages for A (0-2)
                              FPA_PREG=>FPA_PREG,                               -- Pipeline stages for FPA output (0-1)
                              FPBREG=>FPBREG,                                   -- Pipeline stages for B inputs (0-1)
                              FPCREG=>FPCREG,                                   -- Pipeline stages for C input (0-3)
                              FPDREG=>FPDREG,                                   -- Pipeline stages for D inputs (0-1)
                              FPMPIPEREG=>FPMPIPEREG,                           -- Selects the number of FPMPIPE registers (0-1)
                              FPM_PREG=>FPM_PREG,                               -- Pipeline stages for FPM output (0-1)
                              FPOPMREG=>FPOPMREG,                               -- Selects the length of the FPOPMODE pipeline (0-3)
                              INMODEREG=>INMODEREG,                             -- Selects the number of FPINMODE registers (0-1)
                              RESET_MODE=>RESET_MODE)                           -- Selection of synchronous or asynchronous reset. (ASYNC, SYNC).
                  port map(-- Cascade inputs: Cascade Ports
                           ACIN_EXP=>TO_SLV(ACIN,7,0),                          -- 8-bit input: A exponent cascade data
                           ACIN_MAN=>TO_SLV(ACIN,-1,-23),                       -- 23-bit input: A mantissa cascade data
                           ACIN_SIGN=>ACIN(8),                                  -- 1-bit input: A sign cascade data
                           BCIN_EXP=>TO_SLV(BCIN,7,0),                          -- 8-bit input: B exponent cascade data
                           BCIN_MAN=>TO_SLV(BCIN,-1,-23),                       -- 23-bit input: B mantissa cascade data
                           BCIN_SIGN=>BCIN(8),                                  -- 1-bit input: B sign cascade data
                           PCIN=>TO_SLV(PCIN,8,-23),                            -- 32-bit input: P cascade
                           -- Control inputs: Control Inputs/Status Bits
                           CLK=>CLK,                                            -- 1-bit input: Clock
                           FPINMODE=>FPINMODE,                                  -- 1-bit input: Controls select for B/D input data mux.
                           FPOPMODE=>FPOPMODE,                                  -- 7-bit input: Selects input signals to floating-point adder and input negation.
                           -- Data inputs: Data Ports
                           A_EXP=>TO_SLV(A,7,0),                                -- 8-bit input: A data exponent
                           A_MAN=>TO_SLV(A,-1,-23),                             -- 23-bit input: A data mantissa
                           A_SIGN=>A(8),                                        -- 1-bit input: A data sign bit
                           B_EXP=>TO_SLV(B,7,0),                                -- 8-bit input: B data exponent
                           B_MAN=>TO_SLV(B,-1,-23),                             -- 23-bit input: B data mantissa
                           B_SIGN=>B(8),                                        -- 1-bit input: B data sign bit
                           C=>TO_SLV(C,8,-23),                                  -- 32-bit input: C data input in Binary32 format.
                           D_EXP=>TO_SLV(D,7,0),                                -- 8-bit input: D data exponent
                           D_MAN=>TO_SLV(D,-1,-23),                             -- 23-bit input: D data mantissa
                           D_SIGN=>D(8),                                        -- 1-bit input: D data sign bit
                           -- Reset/Clock Enable inputs: Reset/Clock Enable Inputs
                           ASYNC_RST=>ASYNC_RST,                                -- 1-bit input: Asynchronous reset for all registers.
                           CEA1=>CEA1,                                          -- 1-bit input: Clock enable for 1st stage AREG
                           CEA2=>CEA2,                                          -- 1-bit input: Clock enable for 2nd stage AREG
                           CEB=>CEB,                                            -- 1-bit input: Clock enable BREG
                           CEC=>CEC,                                            -- 1-bit input: Clock enable for CREG
                           CED=>CED,                                            -- 1-bit input: Clock enable for DREG
                           CEFPA=>CEFPA,                                        -- 1-bit input: Clock enable for FPA_PREG
                           CEFPINMODE=>CEFPINMODE,                              -- 1-bit input: Clock enable for FPINMODE register
                           CEFPM=>CEFPM,                                        -- 1-bit input: Clock enable for FPM output register.
                           CEFPMPIPE=>CEFPMPIPE,                                -- 1-bit input: Clock enable for FPMPIPE post multiplier register.
                           CEFPOPMODE=>CEFPOPMODE,                              -- 1-bit input: Clock enable for FPOPMODE post multiplier register.
                           RSTA=>RSTA,                                          -- 1-bit input: Reset for AREG
                           RSTB=>RSTB,                                          -- 1-bit input: Reset for BREG
                           RSTC=>RSTC,                                          -- 1-bit input: Reset for CREG
                           RSTD=>RSTD,                                          -- 1-bit input: Reset for DREG
                           RSTFPA=>RSTFPA,                                      -- 1-bit input: Reset for FPA output register
                           RSTFPINMODE=>RSTFPINMODE,                            -- 1-bit input: Reset for FPINMODE register
                           RSTFPM=>RSTFPM,                                      -- 1-bit input: Reset for FPM output register
                           RSTFPMPIPE=>RSTFPMPIPE,                              -- 1-bit input: Reset for FPMPIPE register
                           RSTFPOPMODE=>RSTFPOPMODE,                            -- 1-bit input: Reset for FPOPMODE registers
                           -- Cascade outputs: Cascade Ports
                           ACOUT_EXP=>slvACOUT(30 downto 23),                   -- 8-bit output: A exponent cascade data
                           ACOUT_MAN=>slvACOUT(22 downto 0),                    -- 23-bit output: A mantissa cascade data
                           ACOUT_SIGN=>slvACOUT(31),                            -- 1-bit output: A sign cascade data
                           BCOUT_EXP=>slvBCOUT(30 downto 23),                   -- 8-bit output: B exponent cascade data
                           BCOUT_MAN=>slvBCOUT(22 downto 0),                    -- 23-bit output: B mantissa cascade data
                           BCOUT_SIGN=>slvBCOUT(31),                            -- 1-bit output: B sign cascade data
                           PCOUT=>slvPCOUT,                                     -- 32-bit output: Cascade output
                           -- Data outputs: Data Ports     
                           FPA_INVALID=>FPA_INVALID,                            -- 1-bit output: Invalid flag for FPA output
                           FPA_OUT=>slvFPA_OUT,                                 -- 32-bit output: Adder/accumlator data output in Binary32 format.
                           FPA_OVERFLOW=>FPA_OVERFLOW,                          -- 1-bit output: Overflow signal for adder/accumlator data output
                           FPA_UNDERFLOW=>FPA_UNDERFLOW,                        -- 1-bit output: Underflow signal for adder/accumlator data output
                           FPM_INVALID=>FPM_INVALID,                            -- 1-bit output: Invalid flag for FPM output
                           FPM_OUT=>slvFPM_OUT,                                 -- 32-bit output: Multiplier data output in Binary32 format.
                           FPM_OVERFLOW=>FPM_OVERFLOW,                          -- 1-bit output: Overflow signal for multiplier data output
                           FPM_UNDERFLOW=>FPM_UNDERFLOW);                       -- 1-bit output: Underflow signal for multiplier data output
     end generate;

  FPA_OUT<=FLOAT32(slvFPA_OUT);
  FPM_OUT<=FLOAT32(slvFPM_OUT);
  ACOUT<=FLOAT32(slvACOUT);
  BCOUT<=FLOAT32(slvBCOUT);
  PCOUT<=FLOAT32(slvPCOUT);
end TEST;