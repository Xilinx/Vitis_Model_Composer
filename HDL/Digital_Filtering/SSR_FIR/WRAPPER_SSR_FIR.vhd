library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library STD;
use STD.textio.all;
use STD.env.all;

use work.TYPES_PKG.all;

library UNISIM;
use UNISIM.VComponents.all;

entity WRAPPER_SSR_FIR is
  generic(OX,OY:INTEGER:=-1;---2147483648;  -- Coordinates of the lower left corner DSPx8, use -2147483648 if you do not want floorplanning
          FAMILY:INTEGER:=3;           -- use 1 for 7-series, 2 for US/US+ and 3 for Versal
          DDR:BOOLEAN:=FALSE;              -- use DDR=TRUE implementation only for Versal clock rates over 795MHz/824MHz/872MHz in speed grades -1/-2/-3
          SSR:INTEGER:=4;
          TAPS:INTEGER:=36;
--          COEFFICIENT:REAL_VECTOR(0 to TAPS-1):=(1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0);
          C:STRING:="1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0";
          I_HIGH:INTEGER:=7;
          I_LOW:INTEGER:=-8;
          C_HIGH:INTEGER:=0;
          C_LOW:INTEGER:=-17;
          O_HIGH:INTEGER:=7;
          O_LOW:INTEGER:=-16;
          ROUNDING:BOOLEAN:=FALSE;         -- use TRUE for rounding the output result
          SYMMETRY:STRING:="ES");      -- Filter Symmetry, use "ES" for Even-Symmetric, "OS" for Odd-Symmetric and "NS" for Non-Symmetric
  port(CLK:in STD_LOGIC;
       CE:in STD_LOGIC:='1';           -- not used, for SysGen only
       I:in STD_LOGIC_VECTOR(SSR*(I_HIGH-I_LOW+1)-1 downto 0);
       VI:in STD_LOGIC;
       O:out STD_LOGIC_VECTOR(SSR*(O_HIGH-O_LOW+1)-1 downto 0);
       VO:out STD_LOGIC);
end WRAPPER_SSR_FIR;

architecture WRAPPER of WRAPPER_SSR_FIR is
  signal II:SFIXED_VECTOR(0 to SSR-1,I_HIGH downto I_LOW);
  signal VII:BOOLEAN;
  signal OO:SFIXED_VECTOR(0 to SSR-1,O_HIGH downto O_LOW);
  signal VOO:BOOLEAN;
  function REAL_value(S:STRING) return REAL is
    variable R,F:REAL;
    variable E:INTEGER;
    variable DECIMAL,NEGATIVE,EXP,NEGEXP:BOOLEAN;
  begin
    R:=0.0;F:=1.0;E:=0;
    DECIMAL:=FALSE;
    NEGATIVE:=FALSE;
    EXP:=FALSE;
    NEGEXP:=FALSE;
    for K in 0 to S'length-1 loop
      if (S(K+S'low)='E') or (S(K+S'low)='e') then
        EXP:=TRUE;
      elsif K=0 and S(K+S'low)='-' then
        NEGATIVE:=TRUE;
      elsif EXP then
        if S(K+S'low)='-' then
          NEGEXP:=TRUE;
        else
          case S(K+S'low) is
            when '0'=>E:=E*10;
            when '1'=>E:=E*10+1;
            when '2'=>E:=E*10+2;
            when '3'=>E:=E*10+3;
            when '4'=>E:=E*10+4;
            when '5'=>E:=E*10+5;
            when '6'=>E:=E*10+6;
            when '7'=>E:=E*10+7;
            when '8'=>E:=E*10+8;
            when '9'=>E:=E*10+9;
            when others=>assert FALSE report "REAL number format error!" severity warning;
          end case;
        end if;
      elsif DECIMAL then
        F:=F/10.0;
        case S(K+S'low) is
          when '0'=>null;
          when '1'=>R:=R+1.0*F;
          when '2'=>R:=R+2.0*F;
          when '3'=>R:=R+3.0*F;
          when '4'=>R:=R+4.0*F;
          when '5'=>R:=R+5.0*F;
          when '6'=>R:=R+6.0*F;
          when '7'=>R:=R+7.0*F;
          when '8'=>R:=R+8.0*F;
          when '9'=>R:=R+9.0*F;
          when others=>assert FALSE report "REAL number format error!" severity warning;
        end case;
      else
        case S(K+S'low) is
          when '0'=>R:=R*10.0;
          when '1'=>R:=R*10.0+1.0;
          when '2'=>R:=R*10.0+2.0;
          when '3'=>R:=R*10.0+3.0;
          when '4'=>R:=R*10.0+4.0;
          when '5'=>R:=R*10.0+5.0;
          when '6'=>R:=R*10.0+6.0;
          when '7'=>R:=R*10.0+7.0;
          when '8'=>R:=R*10.0+8.0;
          when '9'=>R:=R*10.0+9.0;
          when '.'=>DECIMAL:=TRUE;
          when others=>assert FALSE report "REAL number format error!" severity warning;
        end case;
      end if;
    end loop;
    if NEGEXP then
      E:=-E;
    end if;
    if NEGATIVE then
      return -R*10.00**E;
    else
      return R*10.0**E;
    end if;
  end;
  function STRING2REAL(S:STRING;N:INTEGER) return REAL_VECTOR is
    variable R:REAL_VECTOR(1 to N);
    variable P,C:INTEGER;
  begin
    P:=S'low;
    if (S(P)='(') or (S(P)='[') then P:=P+1; end if;
    for K in R'range loop
      while (P<S'high) and ((S(P)=' ') or (S(P)=',')) loop
        P:=P+1;
      end loop;
      C:=0;
      while (P+C<=S'high) and (S(P+C)/=' ') and (S(P+C)/=',') loop
        C:=C+1;
      end loop;
      if C>0 
-- REAL'value() not supported in Vivado Synthesis
--        then R(K):=REAL'value(S(P to P+C-1));
        then R(K):=REAL_value(S(P to P+C-1));
        else R(K):=0.0;
      end if;
      P:=P+C;
    end loop;
    return R;
  end;
--  constant COEFFICIENT:REAL_VECTOR(0 to TAPS-1):=(1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0);
  constant COEFFICIENT:REAL_VECTOR(0 to TAPS-1):=STRING2REAL(C,TAPS);
  signal CLK1,CLKH:STD_LOGIC;
begin
  i1:if DDR generate
       b2:MBUFGCE_DIV port map(I=>CLK,
                               CE=>'1',
                               CLR=>'0',
                               CLRB_LEAF=>'1',
                               O1=>CLK1,
                               O2=>CLKH);
      end;
      else generate
        CLK1<=CLK;
        CLKH<='0';
      end generate;
  ij:for J in II'range(1) generate
       ik:for K in II'range(2) generate
            II(J,K)<=I(J*II'length(2)+K-II'low(2));
          end generate;
     end generate;
  VII<=VI='1';
  u1:entity work.SSR_FIR generic map(OX=>OX,
                                     OY=>OY,
                                     FAMILY=>FAMILY,
                                     DDR=>DDR,
                                     COEFFICIENT=>COEFFICIENT,
                                     C_HIGH=>C_HIGH,
                                     C_LOW=>C_LOW,
                                     ROUNDING=>ROUNDING,
                                     SYMMETRY=>SYMMETRY)
                         port map (CLK=>CLK1,
                                   CLKH=>CLKH,
                                   I=>II,
                                   VI=>VII,
                                   O=>OO,
                                   VO=>VOO);
  oj:for J in OO'range(1) generate
       ok:for K in OO'range(2) generate
            O(J*OO'length(2)+K-OO'low(2))<=OO(J,K);
          end generate;
     end generate;
  VO<='1' when VOO else '0';
end WRAPPER;