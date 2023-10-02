library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- FLOAT32 is defined here
use IEEE.NUMERIC_STD.ALL; -- contains definition of FLOAT32_MATRIX

use work.FLOAT_PKG.all;
use work.CFLOAT_PKG.all;

entity DET3x3 is
  port(CLK:in STD_LOGIC;
       CE:in STD_LOGIC:='1'; -- Model Composer requires a CE even if it is not used, tdefault value means it can be left unconnected
--       I:in FLOAT32_MATRIX(1 to 3)(1 to 3);
       I11,I21,I31:in FLOAT32;
       I12,I22,I32:in FLOAT32;
       I13,I23,I33:in FLOAT32;
       VI:in BOOLEAN;
       O:out FLOAT32;
       VO:out BOOLEAN);
end DET3x3;

architecture TEST of DET3x3 is
  signal DET2x2:FLOAT32_VECTOR(1 to 3);
  signal DET2x2D:FLOAT32_VECTOR(1 to 1);
  signal I11D5,I12D4,I13D4:FLOAT32;
  signal PC1,PC3,PC5,PC7,PC8:FLOAT32;
begin
  s1:entity work.DELAY generic map(SIZE=>5)
                       port map(CLK=>CLK,
--                                I=>I(1)(1),
                                I=>I11,
                                O=>I11D5);

  s2:entity work.DELAY generic map(SIZE=>4)
                       port map(CLK=>CLK,
--                                I=>I(1)(2),
                                I=>I12,
                                O=>I12D4);

  s3:entity work.DELAY generic map(SIZE=>4)
                       port map(CLK=>CLK,
--                                I=>I(1)(3),
                                I=>I13,
                                O=>I13D4);

  s4:entity work.DELAY generic map(SIZE=>1)
                       port map(CLK=>CLK,
                                I=>DET2x2(1),
                                O=>DET2x2D(1));

  d1:entity work.DSPFP32_GW generic map(PCOUTSEL=>"FPM")
                            port map(CLK=>CLK,
--                                     A=>I(2)(1),
--                                     B=>I(3)(2),
--                                     FPOPMODE=>7x"01",
                                     A=>I21,
                                     B=>I32,
                                     FPOPMODE=>"0000001",
                                     PCOUT=>PC1);

  d2:entity work.DSPFP32_GW port map(CLK=>CLK,
--                                     A=>I(2)(2),
--                                     B=>I(3)(1),
--                                     FPOPMODE=>7x"3D",
                                     A=>I22,
                                     B=>I31,
                                     FPOPMODE=>"0111101",
                                     PCIN=>PC1,
                                     FPA_OUT=>DET2x2(3));

  d3:entity work.DSPFP32_GW generic map(PCOUTSEL=>"FPM")
                            port map(CLK=>CLK,
--                                     A=>I(2)(1),
--                                     B=>I(3)(3),
--                                     FPOPMODE=>7x"01",
                                     A=>I21,
                                     B=>I33,
                                     FPOPMODE=>"0000001",
                                     PCOUT=>PC3);

  d4:entity work.DSPFP32_GW port map(CLK=>CLK,
--                                     A=>I(3)(1),
--                                     B=>I(2)(3),
--                                     FPOPMODE=>7x"3D",
                                     A=>I31,
                                     B=>I23,
                                     FPOPMODE=>"0111101",
                                     PCIN=>PC3,
                                     FPA_OUT=>DET2x2(2));

  d5:entity work.DSPFP32_GW generic map(PCOUTSEL=>"FPM")
                            port map(CLK=>CLK,
--                                     A=>I(2)(2),
--                                     B=>I(3)(3),
--                                     FPOPMODE=>7x"01",
                                     A=>I22,
                                     B=>I33,
                                     FPOPMODE=>"0000001",
                                     PCOUT=>PC5);

  d6:entity work.DSPFP32_GW port map(CLK=>CLK,
--                                     A=>I(3)(2),
--                                     B=>I(2)(3),
--                                     FPOPMODE=>7x"3D",
                                     A=>I32,
                                     B=>I23,
                                     FPOPMODE=>"0111101",
                                     PCIN=>PC5,
                                     FPA_OUT=>DET2x2(1));

  d7:entity work.DSPFP32_GW generic map(PCOUTSEL=>"FPM")
                            port map(CLK=>CLK,
                                     A=>I13D4,
                                     B=>DET2x2(3),
--                                     FPOPMODE=>7x"01",
                                     FPOPMODE=>"0000001",
                                     PCOUT=>PC7);

  d8:entity work.DSPFP32_GW generic map(PCOUTSEL=>"FPA")
                            port map(CLK=>CLK,
                                     A=>I12D4,
                                     B=>DET2x2(2),
--                                     FPOPMODE=>7x"3D",
                                     FPOPMODE=>"0111101",
                                     PCIN=>PC7,
                                     PCOUT=>PC8);

  d9:entity work.DSPFP32_GW port map(CLK=>CLK,
                                     A=>I11D5,
                                     B=>DET2x2D(1),
--                                     FPOPMODE=>7x"1D",
                                     FPOPMODE=>"0011101",
                                     PCIN=>PC8,
                                     FPA_OUT=>O);

  bd:entity work.BDELAY generic map(SIZE=>9)
                        port map(CLK=>CLK,
                                 I=>VI,
                                 O=>VO);
end TEST;
