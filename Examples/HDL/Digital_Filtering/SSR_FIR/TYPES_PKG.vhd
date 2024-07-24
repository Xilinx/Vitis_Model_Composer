-- Copyright (C) 2024, Advanced Micro Devices, Inc.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.math_complex.all;

package TYPES_PKG is
--  constant I_SIZE:INTEGER:=16;
--  constant C_SIZE:INTEGER:=16;
--  constant O_SIZE:INTEGER:=36;
--  type BOOLEAN_VECTOR is array(NATURAL range <>) of BOOLEAN;
--  type INTEGER_VECTOR is array(INTEGER range <>) of INTEGER;
--  type REAL_VECTOR is array(INTEGER range <>) of REAL;
--  type COMPLEX_VECTOR is array(INTEGER range <>) of COMPLEX;
--  type I_VECTOR is array(INTEGER range <>) of STD_LOGIC_VECTOR(I_SIZE-1 downto 0);
--  type O_VECTOR is array(INTEGER range <>) of STD_LOGIC_VECTOR(O_SIZE-1 downto 0);
--  type SI_VECTOR is array(INTEGER range <>) of SIGNED(I_SIZE-1 downto 0);
--  type SO_VECTOR is array(INTEGER range <>) of SIGNED(O_SIZE-1 downto 0);
--  type SI_MATRIX is array(INTEGER range <>,INTEGER range <>) of SIGNED(I_SIZE-1 downto 0);

  function LOG2(N:INTEGER) return INTEGER;

--  type REAL_VECTOR is array(INTEGER range <>) of REAL;
  type COMPLEX_VECTOR is array(INTEGER range <>) of COMPLEX;

  type SFIXED is array(INTEGER range <>) of STD_LOGIC;
  type SFIXED_VECTOR is array(INTEGER range <>,INTEGER range <>) of STD_LOGIC;
  type SFIXED_MATRIX is array(INTEGER range <>,INTEGER range <>,INTEGER range <>) of STD_LOGIC;

  type CFIXED is array(INTEGER range <>) of STD_LOGIC; -- CFIXED'high must be odd and CFIXED'low must be even
  type CFIXED_VECTOR is array(INTEGER range <>,INTEGER range <>) of STD_LOGIC; -- CFIXED'high(2) must be odd and CFIXED'low(2) must be even
  type CFIXED_MATRIX is array(INTEGER range <>,INTEGER range <>,INTEGER range <>) of STD_LOGIC; -- CFIXED'high(3) must be odd and CFIXED'low(3) must be even

  function MIN(A,B:INTEGER) return INTEGER;
  function MIN(A,B,C:INTEGER) return INTEGER;
  function MIN(A,B,C,D:INTEGER) return INTEGER;
  function MAX(A,B:INTEGER) return INTEGER;
  function MAX(A,B,C:INTEGER) return INTEGER;
  function MAX(A,B,C,D:INTEGER) return INTEGER;
  function MED(A,B,C:INTEGER) return INTEGER;
  function "+"(X,Y:SFIXED) return SFIXED; -- full precision add with SFIXED(MAX(X'high,Y'high)+1 downto MIN(X'low,Y'low)) result
  function "-"(X,Y:SFIXED) return SFIXED; -- full precision subtract with SFIXED(MAX(X'high,Y'high)+1 downto MIN(X'low,Y'low)) result
  function "-"(X:SFIXED) return SFIXED; -- full precision negate with SFIXED(X'high+1 downto X'low) result
  function "*"(X,Y:SFIXED) return SFIXED; -- full precision multiply with SFIXED(X'high+Y'high+1 downto X'low+Y'low) result
  function "*"(X:SFIXED;Y:STD_LOGIC) return SFIXED; -- multiply by 0 or 1 with SFIXED(X'high downto X'low) result
  function RESIZE(X:SFIXED;H,L:INTEGER) return SFIXED; -- resizes X and returns SFIXED(H downto L)
  function RESIZE(X:SFIXED;HL:SFIXED) return SFIXED; -- resizes X to match HL and returns SFIXED(HL'high downto HL'low)
  function SHIFT_RIGHT(X:SFIXED;N:INTEGER) return SFIXED; -- returns SFIXED(X'high-N downto X'low-N) result
  function SHIFT_LEFT(X:SFIXED;N:INTEGER) return SFIXED; -- returns SFIXED(X'high+N downto X'low+N) result
  function TO_SFIXED(R:REAL;H,L:INTEGER) return SFIXED; -- returns SFIXED(H downto L) result
  function TO_SFIXED(R:REAL;HL:SFIXED) return SFIXED; -- returns SFIXED(HL'high downto HL'low) result
  function TO_SFIXED(I:SIGNED;H,L:INTEGER;SHIFT:INTEGER:=0) return SFIXED; -- convert SIGNED to SFIXED(H downto L) and resize
  function TO_SFIXED(I:SIGNED;X:SFIXED;SHIFT:INTEGER:=0) return SFIXED; -- convert SIGNED to SFIXED(X'high downto X'low) and resize
  function TO_SIGNED(I:SFIXED;X:SFIXED) return SIGNED; -- resize I to X and convert to SIGNED(I'length-1 downto 0), returns SIGNED(SHIFT_RIGHT(RESIZE(I,X),X'low))
  function TO_REAL(S:SFIXED) return REAL; -- returns REAL result
  function TO_01(X:SFIXED) return SFIXED; -- get rid of Xes
-- all SET calls targetting the same signal must be located in a single process!
  function GET(A:SFIXED_VECTOR;I:INTEGER) return SFIXED; -- A(I)
  function GET(A:SFIXED_MATRIX;I,J:INTEGER) return SFIXED; -- A(I,J)
  function GET(A:SFIXED_MATRIX;I:INTEGER) return SFIXED_VECTOR; -- A(I)
  procedure SET(signal A:inout SFIXED_VECTOR;constant I:INTEGER;signal V:SFIXED); -- A(I)<=V;
  procedure SET(signal A:inout SFIXED_MATRIX;constant I,J:INTEGER;signal V:SFIXED); -- A(I,J)<=V;
  procedure SET(signal A:inout SFIXED_MATRIX;constant I:INTEGER;signal V:SFIXED_VECTOR); -- A(I)<=V;

  function RE(A:CFIXED) return SFIXED; -- A.RE
  function IM(A:CFIXED) return SFIXED; -- A.IM
  procedure RE(signal A:inout CFIXED;constant V:SFIXED); -- A.RE<=RESIZE(V,A.RE);
  procedure IM(signal A:inout CFIXED;constant V:SFIXED); -- A.IM<=RESIZE(V,A.IM);
  function "+"(X,Y:CFIXED) return CFIXED; -- full precision add with CFIXED(MAX(X'high,Y'high)+2 downto MIN(X'low,Y'low)) result
  function "-"(X,Y:CFIXED) return CFIXED; -- full precision subtract with CFIXED(MAX(X'high,Y'high)+2 downto MIN(X'low,Y'low)) result
  function "*"(X,Y:CFIXED) return CFIXED; -- full precision multiply with CFIXED(X'high+Y'high+2 downto X'low+Y'low) result
  function "*"(X:CFIXED;Y:SFIXED) return CFIXED; -- full precision multiply with CFIXED(X'high+Y'high downto X'low+Y'low) result
  function "*"(X:SFIXED;Y:CFIXED) return CFIXED;
  function RESIZE(X:CFIXED;H,L:INTEGER) return CFIXED; -- resizes X and returns CFIXED(RE(H downto L),IM(H downto L))
  function RESIZE(X:CFIXED;HL:CFIXED) return CFIXED; -- resizes X to match HL and returns CFIXED(RE(HL.RE'high downto HL.RE'low),IM(RE(HL.IM'high downto HL.IM'low))
  function PLUS_i_TIMES(X:CFIXED) return CFIXED; -- returns CFIXED(X'high+2 downto X'low) result
  function "-"(X:CFIXED) return CFIXED; -- full precision negate with CFIXED(X'high+2 downto X'low) result
  function MINUS_i_TIMES(X:CFIXED) return CFIXED; -- returns CFIXED(X'high+2 downto X'low) result
  function X_PLUS_i_TIMES_Y(X,Y:CFIXED;RND:CFIXED) return CFIXED; -- returns CFIXED(MAX(X'high,Y'high)+2 downto MIN(X'low,Y'low)) result
  function X_MINUS_i_TIMES_Y(X,Y:CFIXED;RND:CFIXED) return CFIXED; -- returns CFIXED(MAX(X'high,Y'high)+2 downto MIN(X'low,Y'low)) result
  function SWAP(X:CFIXED) return CFIXED; -- returns CFIXED(X'high downto X'low) result
  function CONJ(X:CFIXED) return CFIXED; -- returns CFIXED(X'high+2 downto X'low) result
  function SHIFT_RIGHT(X:CFIXED;N:INTEGER) return CFIXED; -- returns CFIXED(X'high-N downto X'low-N) result
  function SHIFT_LEFT(X:CFIXED;N:INTEGER) return CFIXED; -- returns CFIXED(X'high+N downto X'low+N) result
  function TO_CFIXED(R,I:REAL;H,L:INTEGER) return CFIXED; -- returns CFIXED(RE(H downto L),IM(H downto L)) result
  function TO_CFIXED(R,I:REAL;HL:CFIXED) return CFIXED; -- returns CFIXED(RE(HL.RE'high downto HL.RE'low),IM(RE(HL.IM'high downto HL.IM'low)) result
  function TO_CFIXED(C:COMPLEX;HL:CFIXED) return CFIXED; -- returns CFIXED(RE(HL.RE'high downto HL.RE'low),IM(RE(HL.IM'high downto HL.IM'low)) result
  function TO_CFIXED(R,I:SFIXED) return CFIXED; -- returns CFIXED(2*MAX(R'high,I'high)+1 downto 2*MIN(R'low,I'low)) result
  function TO_COMPLEX(C:CFIXED) return COMPLEX; -- returns COMPLEX result
/*
  function TO_CFIXED_VECTOR(C:COMPLEX_VECTOR;HL:CFIXED) return CFIXED_VECTOR; -- returns CFIXED_VECTOR(RE(HL.RE'high downto HL.RE'low),IM(RE(HL.IM'high downto HL.IM'low)) result
  function TO_COMPLEX_VECTOR(C:CFIXED_VECTOR) return COMPLEX_VECTOR; -- returns COMPLEX_VECTOR result
*/
  function "*"(R:REAL;C:COMPLEX_VECTOR) return COMPLEX_VECTOR; -- returns R*C
  function ZERO(U:UNSIGNED) return UNSIGNED; -- returns 0 with the same range as U
  function ZERO(S:SFIXED) return SFIXED; -- returns 0 with the same range as S
  function ZERO(C:CFIXED) return CFIXED; -- returns 0 with the same range as C
  function ZERO(SV:SFIXED_VECTOR) return SFIXED_VECTOR; -- returns 0 with the same range as SV
  function ZERO(CV:CFIXED_VECTOR) return CFIXED_VECTOR; -- returns 0 with the same range as CV

  function GET(A:CFIXED_VECTOR;I:INTEGER) return CFIXED; -- A(I)
  function GET(A:CFIXED_MATRIX;I,J:INTEGER) return CFIXED; -- A(I,J)
  function GET(A:CFIXED_MATRIX;I:INTEGER) return CFIXED_VECTOR; -- A(I)
  procedure SET(signal A:inout CFIXED_VECTOR;constant I:INTEGER;signal V:CFIXED); -- A(I)<=V;
  procedure SET(signal A:inout CFIXED_MATRIX;constant I,J:INTEGER;signal V:CFIXED); -- A(I,J)<=V;
  procedure SET(signal A:inout CFIXED_MATRIX;constant I:INTEGER;signal V:CFIXED_VECTOR); -- A(I)<=V;
end TYPES_PKG;

package body TYPES_PKG is
  function LOG2(N:INTEGER) return INTEGER is
    variable TEMP:INTEGER;
    variable RESULT:INTEGER;
  begin
    TEMP:=N;
    RESULT:=0;
    while TEMP>1 loop
      RESULT:=RESULT+1;
      TEMP:=(TEMP+1)/2;
    end loop;  
    return RESULT; 
  end; 

  function MIN(A,B:INTEGER) return INTEGER is
  begin
    if A<B then
      return A;
    else
      return B;
    end if;
  end;
  
  function MIN(A,B,C:INTEGER) return INTEGER is
  begin
    return MIN(MIN(A,B),C);
  end;
  
  function MIN(A,B,C,D:INTEGER) return INTEGER is
  begin
    return MIN(MIN(A,B),MIN(C,D));
  end;
  
  function MAX(A,B:INTEGER) return INTEGER is
  begin
    if A>B then
      return A;
    else
      return B;
    end if;
  end;
  
  function MAX(A,B,C:INTEGER) return INTEGER is
  begin
    return MAX(MAX(A,B),C);
  end;
  
  function MAX(A,B,C,D:INTEGER) return INTEGER is
  begin
    return MAX(MAX(A,B),MAX(C,D));
  end;
  
  function MED(A,B,C:INTEGER) return INTEGER is
  begin
    return MAX(MIN(MAX(A,B),C),MIN(A,B));
  end;
  
  function "+"(X,Y:SFIXED) return SFIXED is
    variable SX,SY,SR:SIGNED(MAX(X'high,Y'high)+1-MIN(X'low,Y'low) downto 0);
    variable R:SFIXED(MAX(X'high,Y'high)+1 downto MIN(X'low,Y'low));
  begin
    for K in SX'range loop
      if K<X'low-Y'low then
        SX(K):='0';           -- zero pad X LSBs
      elsif K>X'high-R'low then
        SX(K):=X(X'high);     -- sign extend X MSBs
      else
        SX(K):=X(R'low+K);
      end if;
    end loop;
    for K in SY'range loop
      if K<Y'low-X'low then
        SY(K):='0';           -- zero pad Y LSBs
      elsif K>Y'high-R'low then
        SY(K):=Y(Y'high);     -- sign extend Y MSBs
      else
        SY(K):=Y(R'low+K);
      end if;
    end loop;
    SR:=SX+SY; -- SIGNED addition
    for K in SR'range loop
      R(R'low+K):=SR(K);
    end loop;
    return R;
  end;
  
  function "-"(X,Y:SFIXED) return SFIXED is
    variable SX,SY,SR:SIGNED(MAX(X'high,Y'high)+1-MIN(X'low,Y'low) downto 0);
    variable R:SFIXED(MAX(X'high,Y'high)+1 downto MIN(X'low,Y'low));
  begin
    for K in SX'range loop
      if K<X'low-Y'low then
        SX(K):='0';           -- zero pad X LSBs
      elsif K>X'high-R'low then
        SX(K):=X(X'high);     -- sign extend X MSBs
      else
        SX(K):=X(R'low+K);
      end if;
    end loop;
    for K in SY'range loop
      if K<Y'low-X'low then
        SY(K):='0';           -- zero pad Y LSBs
      elsif K>Y'high-R'low then
        SY(K):=Y(Y'high);     -- sign extend Y MSBs
      else
        SY(K):=Y(R'low+K);
      end if;
    end loop;
    SR:=SX-SY; -- SIGNED subtraction
    for K in SR'range loop
      R(R'low+K):=SR(K);
    end loop;
    return R;
  end;
  
  function "-"(X:SFIXED) return SFIXED is
    variable SX:SIGNED(X'high-X'low downto 0);
    variable SR:SIGNED(X'high-X'low+1 downto 0);
    variable R:SFIXED(X'high+1 downto X'low);
  begin
    for K in SX'range loop
      SX(K):=X(X'low+K);
    end loop;
    SR:=-RESIZE(SX,SR'length); -- SIGNED negation
    for K in SR'range loop
      R(R'low+K):=SR(K);
    end loop;
    return R;
  end;
  
  function "*"(X,Y:SFIXED) return SFIXED is
    variable SX:SIGNED(X'high-X'low downto 0);
    variable SY:SIGNED(Y'high-Y'low downto 0);
    variable SR:SIGNED(SX'high+SY'high+1 downto 0);
    variable R:SFIXED(X'high+Y'high+1 downto X'low+Y'low);
  begin
    for K in SX'range loop
      SX(K):=X(X'low+K);
    end loop;
    for K in SY'range loop
      SY(K):=Y(Y'low+K);
    end loop;
    SR:=SX*SY; -- SIGNED multiplication
    for K in SR'range loop
      R(R'low+K):=SR(K);
    end loop;
    return R;
  end;
  
  function "*"(X:SFIXED;Y:STD_LOGIC) return SFIXED is
  begin
    if Y='1' then
      return X;
    else
      return TO_SFIXED(0.0,X);
    end if;
  end;
  
  function RESIZE(X:SFIXED;H,L:INTEGER) return SFIXED is
    variable R:SFIXED(H downto L);
  begin
    for K in R'range loop
      if K<X'low then
        R(K):='0';           -- zero pad X LSBs
      elsif K>X'high then
        R(K):=X(X'high);     -- sign extend X MSBs
      else
        R(K):=X(K);
      end if;
    end loop;
    return R;
  end;
  
  function RESIZE(X:SFIXED;HL:SFIXED) return SFIXED is
  begin
    return RESIZE(X,HL'high,HL'low);
  end;
  
  function SHIFT_RIGHT(X:SFIXED;N:INTEGER) return SFIXED is
    variable R:SFIXED(X'high-N downto X'low-N);
  begin
    for K in R'range loop
      R(K):=X(K+N);
    end loop;
    return R;
  end;
  
  function SHIFT_LEFT(X:SFIXED;N:INTEGER) return SFIXED is
    variable R:SFIXED(X'high+N downto X'low+N);
  begin
    for K in R'range loop
      R(K):=X(K-N);
    end loop;
    return R;
  end;

  function TO_SFIXED(R:REAL;H,L:INTEGER) return SFIXED is
    variable RR:REAL;
    variable V:SFIXED(H downto L);
  begin
    assert (R<2.0**H) and (R>=-2.0**H) report "TO_SFIXED vector truncation!" severity warning;
    if R<0.0 then
      V(V'high):='1';
      RR:=R+2.0**V'high;
    else
      V(V'high):='0';
      RR:=R;
    end if;
    for K in V'high-1 downto V'low loop
      if RR>=2.0**K then
        V(K):='1';
        RR:=RR-2.0**K;
      else
        V(K):='0';
      end if;
    end loop;
    return V;
  end;
  
  function TO_SFIXED(R:REAL;HL:SFIXED) return SFIXED is
  begin
    return TO_SFIXED(R,HL'high,HL'low);
  end;

  function TO_SFIXED(I:SIGNED;H,L:INTEGER;SHIFT:INTEGER:=0) return SFIXED is
    variable O:SFIXED(H downto L);
  begin
    for K in O'range loop
      if K<I'low+L+SHIFT then
        O(K):='0';
      elsif K-L-SHIFT<I'length then
        O(K):=I(K-L-SHIFT);
      else
        O(K):=I(I'high);
      end if;
    end loop;
    return O;
  end;

  function TO_SFIXED(I:SIGNED;X:SFIXED;SHIFT:INTEGER:=0) return SFIXED is
    variable O:SFIXED(X'range);
  begin
    return TO_SFIXED(I,X'high,X'low,SHIFT);
--    for K in O'range loop
--      if K<I'low+X'low+SHIFT then
--        O(K):='0';
--      elsif K-X'low-SHIFT<I'length then
--        O(K):=I(K-X'low-SHIFT);
--      else
--        O(K):=I(I'high);
--      end if;
--    end loop;
--    return O;
  end;

  function TO_SIGNED(I:SFIXED;X:SFIXED) return SIGNED is -- SIGNED(SHIFT_RIGHT(RESIZE(I,X),X'low))
    variable O:SIGNED(X'length-1 downto 0);
  begin
    for K in O'range loop
      if K<I'low-X'low then
        O(K):='0';
      elsif K<I'length then
        O(K):=I(K+X'low);
      else
        O(K):=I(I'high);
      end if;
    end loop;
    return O;
  end;
  
  function TO_REAL(S:SFIXED) return REAL is
    variable R:REAL;
  begin
    R:=0.0;
    for K in S'range loop
      if K=S'high then
        if S(K)='1' then
          R:=R-2.0**K;
        end if;
      else
        if S(K)='1' then
          R:=R+2.0**K;
        end if;
      end if;
    end loop;
    return R;
  end;
  
  function TO_01(X:SFIXED) return SFIXED is -- get rid of Xes
    variable R:SFIXED(X'range);
  begin
    for K in X'range loop
      R(K):=TO_01(X(K));
    end loop;
    return R;
  end;
  
  function GET(A:SFIXED_VECTOR;I:INTEGER) return SFIXED is
    variable R:SFIXED(A'range(2));
  begin
    for K in R'range loop
      R(K):=A(I,K);
    end loop;
    return R;
  end;

  function GET(A:SFIXED_MATRIX;I,J:INTEGER) return SFIXED is
    variable R:SFIXED(A'range(3));
  begin
    for K in R'range loop
      R(K):=A(I,J,K);
    end loop;
    return R;
  end;

  function GET(A:SFIXED_MATRIX;I:INTEGER) return SFIXED_VECTOR is
    variable R:SFIXED_VECTOR(A'range(1),A'range(3));
  begin
    for J in R'range(1) loop
      for K in R'range(2) loop
        R(J,K):=A(I,J,K);
      end loop;
    end loop;
    return R;
  end;

  procedure SET(signal A:inout SFIXED_VECTOR;constant I:INTEGER;signal V:SFIXED) is
  begin
    for K in A'range(2) loop
      if K<V'low then
        A(I,K)<='0';           -- zero pad V LSBs
      elsif K>V'high then
        A(I,K)<=V(V'high);     -- sign extend V MSBs
      else
        A(I,K)<=V(K);
      end if;
    end loop;
  end;

  procedure SET(signal A:inout SFIXED_MATRIX;constant I,J:INTEGER;signal V:SFIXED) is
  begin
    for K in A'range(3) loop
      if K<V'low then
        A(I,J,K)<='0';           -- zero pad V LSBs
      elsif K>V'high then
        A(I,J,K)<=V(V'high);     -- sign extend V MSBs
      else
        A(I,J,K)<=V(K);
      end if;
    end loop;
  end;

  procedure SET(signal A:inout SFIXED_MATRIX;constant I:INTEGER;signal V:SFIXED_VECTOR) is
  begin
    for J in V'range(1) loop
      for K in A'range(3) loop
        if K<V'low(2) then
          A(I,J,K)<='0';           -- zero pad V(J) LSBs
        elsif K>V'high(2) then
          A(I,J,K)<=V(J,V'high(2));     -- sign extend V(J) MSBs
        else
          A(I,J,K)<=V(J,K);
        end if;
     end loop;
    end loop;
  end;

  function RE(A:CFIXED) return SFIXED is
    variable R:SFIXED(A'high/2 downto A'low/2);
  begin
    for K in R'range loop
      R(K):=A(2*K);
    end loop;
    return R;
  end;
  
  function IM(A:CFIXED) return SFIXED is
    variable R:SFIXED(A'high/2 downto A'low/2);
  begin
    for K in R'range loop
      R(K):=A(2*K+1);
    end loop;
    return R;
  end;

  procedure RE(signal A:inout CFIXED;constant V:SFIXED) is
  begin
    for K in A'low/2 to A'high/2 loop
      if K<V'low then
        A(2*K)<='0';           -- zero pad V LSBs
      elsif K>V'high then
        A(2*K)<=V(V'high);     -- sign extend V MSBs
      else
        A(2*K)<=V(K);
      end if;
    end loop;
  end;

  procedure IM(signal A:inout CFIXED;constant V:SFIXED) is
  begin
    for K in A'low/2 to A'high/2 loop
      if K<V'low then
        A(2*K+1)<='0';           -- zero pad V LSBs
      elsif K>V'high then
        A(2*K+1)<=V(V'high);     -- sign extend V MSBs
      else
        A(2*K+1)<=V(K);
      end if;
    end loop;
  end;
  
  function "+"(X,Y:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(RE(X)+RE(Y),IM(X)+IM(Y));
  end;
  
  function "-"(X,Y:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(RE(X)-RE(Y),IM(X)-IM(Y));
  end;
  
  function "*"(X,Y:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(RE(X)*RE(Y)-IM(X)*IM(Y),RE(X)*IM(Y)+IM(X)*RE(Y));
  end;

  function "*"(X:CFIXED;Y:SFIXED) return CFIXED is
  begin
    return TO_CFIXED(RE(X)*Y,IM(X)*Y);
  end;

  function "*"(X:SFIXED;Y:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(X*RE(Y),X*IM(Y));
  end;

  function RESIZE(X:CFIXED;H,L:INTEGER) return CFIXED is
  begin
    return TO_CFIXED(RESIZE(RE(X),H,L),RESIZE(IM(X),H,L));
  end;
  
  function RESIZE(X:CFIXED;HL:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(RESIZE(RE(X),RE(HL)),RESIZE(IM(X),IM(HL)));
  end;
  
  function PLUS_i_TIMES(X:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(-IM(X),RE(X));
  end;
  
  function "-"(X:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(-RE(X),-IM(X));
  end;
  
  function MINUS_i_TIMES(X:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(IM(X),-RE(X));
  end;
  
  function X_PLUS_i_TIMES_Y(X,Y:CFIXED;RND:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(RE(X)-IM(Y)+RE(RND),IM(X)+RE(Y)+IM(RND));
  end;
  
  function X_MINUS_i_TIMES_Y(X,Y:CFIXED;RND:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(RE(X)+IM(Y)+RE(RND),IM(X)-RE(Y)+IM(RND));
  end;
  
  function SWAP(X:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(IM(X),RE(X));
  end;
  
  function CONJ(X:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(RE(X),-IM(X));
  end;
  
  function SHIFT_RIGHT(X:CFIXED;N:INTEGER) return CFIXED is
  begin
    return TO_CFIXED(SHIFT_RIGHT(RE(X),N),SHIFT_RIGHT(IM(X),N));
  end;
  
  function SHIFT_LEFT(X:CFIXED;N:INTEGER) return CFIXED is
  begin
    return TO_CFIXED(SHIFT_LEFT(RE(X),N),SHIFT_LEFT(IM(X),N));
  end;
  
  function TO_CFIXED(R,I:REAL;H,L:INTEGER) return CFIXED is
  begin
    return TO_CFIXED(TO_SFIXED(R,H,L),TO_SFIXED(I,H,L));
  end;
  
  function TO_CFIXED(R,I:REAL;HL:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(TO_SFIXED(R,HL'high/2,HL'low/2),TO_SFIXED(I,HL'high/2,HL'low/2));
  end;
  
  function TO_CFIXED(C:COMPLEX;HL:CFIXED) return CFIXED is
  begin
    return TO_CFIXED(C.RE,C.IM,HL);
  end;
  
  function TO_CFIXED(R,I:SFIXED) return CFIXED is
    constant H:INTEGER:=MAX(R'high,I'high);
    constant L:INTEGER:=MIN(R'low,I'low);
    variable C:CFIXED(2*H+1 downto 2*L);
  begin
    for K in C'low/2 to C'high/2 loop
      if K<R'low then
        C(2*K):='0';           -- zero pad R LSBs
      elsif K>R'high then
        C(2*K):=R(R'high);     -- sign extend R MSBs
      else
        C(2*K):=R(K);
      end if;
    end loop;
    for K in C'low/2 to C'high/2 loop
      if K<I'low then
        C(2*K+1):='0';           -- zero pad I LSBs
      elsif K>I'high then
        C(2*K+1):=I(I'high);     -- sign extend I MSBs
      else
        C(2*K+1):=I(K);
      end if;
    end loop;
    return C;
  end;

  function TO_COMPLEX(C:CFIXED) return COMPLEX is
    variable R:COMPLEX;
  begin
    R.RE:=TO_REAL(RE(C));
    R.IM:=TO_REAL(IM(C));
    return R;
  end;
/*  
  function TO_CFIXED_VECTOR(C:COMPLEX_VECTOR;HL:CFIXED) return CFIXED_VECTOR is
    variable R:CFIXED_VECTOR(C'range,HL'range);
  begin
    for K in C'range loop
      R(K):=TO_CFIXED(C(K),HL);
    end loop;
    return R;
  end;

  function TO_COMPLEX_VECTOR(C:CFIXED_VECTOR) return COMPLEX_VECTOR is
    variable R:COMPLEX_VECTOR(C'range);
  begin
    for K in C'range loop
      R(K):=TO_COMPLEX(C(K));
    end loop;
    return R;
  end;
*/
  function "*"(R:REAL;C:COMPLEX_VECTOR) return COMPLEX_VECTOR is
    variable X:COMPLEX_VECTOR(C'range);
  begin
    for K in C'range loop
      X(K):=R*C(K);
    end loop;
    return X;
  end;

  function ZERO(U:UNSIGNED) return UNSIGNED is -- returns 0 with the same range as S
  begin
    return TO_UNSIGNED(0,U'length); 
  end; 

  function ZERO(S:SFIXED) return SFIXED is -- returns 0 with the same range as S
  begin
    return TO_SFIXED(0.0,S); 
  end; 

  function ZERO(C:CFIXED) return CFIXED is -- returns 0 with the same range as C
  begin
    return TO_CFIXED(0.0,0.0,C); 
  end; 

  function ZERO(SV:SFIXED_VECTOR) return SFIXED_VECTOR is -- returns 0 with the same range as SV
    variable RESULT:SFIXED_VECTOR(SV'range(1),SV'range(2));
  begin
    RESULT:=(others=>(others=>'0')); 
    return RESULT; 
  end; 

  function ZERO(CV:CFIXED_VECTOR) return CFIXED_VECTOR is -- returns 0 with the same range as CV
    variable RESULT:CFIXED_VECTOR(CV'range(1),CV'range(2));
  begin
    RESULT:=(others=>(others=>'0')); 
    return RESULT; 
  end; 

  function GET(A:CFIXED_VECTOR;I:INTEGER) return CFIXED is
    variable R:CFIXED(A'range(2));
  begin
    for K in R'range loop
      R(K):=A(I,K);
    end loop;
    return R;
  end;

  function GET(A:CFIXED_MATRIX;I,J:INTEGER) return CFIXED is
    variable R:CFIXED(A'range(3));
  begin
    for K in R'range loop
      R(K):=A(I,J,K);
    end loop;
    return R;
  end;

  function GET(A:CFIXED_MATRIX;I:INTEGER) return CFIXED_VECTOR is
    variable R:CFIXED_VECTOR(A'range(1),A'range(3));
  begin
    for J in R'range(1) loop
      for K in R'range(2) loop
        R(J,K):=A(I,J,K);
      end loop;
    end loop;
    return R;
  end;

  procedure SET(signal A:inout CFIXED_VECTOR;constant I:INTEGER;signal V:CFIXED) is
  begin
    for K in A'range(2) loop
      if K<V'low then
        A(I,K)<='0';           -- zero pad V.RE and V.IM LSBs
      elsif K>V'high then
        A(I,K)<=V(V'high+K mod 2-1);     -- sign extend V.RE and V.IM MSBs
      else
        A(I,K)<=V(K);
      end if;
    end loop;
  end;

  procedure SET(signal A:inout CFIXED_MATRIX;constant I,J:INTEGER;signal V:CFIXED) is
  begin
    for K in A'range(3) loop
      if K<V'low then
        A(I,J,K)<='0';           -- zero pad V.RE and V.IM LSBs
      elsif K>V'high then
        A(I,J,K)<=V(V'high+K mod 2-1);     -- sign extend V.RE and V.IM MSBs
      else
        A(I,J,K)<=V(K);
      end if;
    end loop;
  end;

  procedure SET(signal A:inout CFIXED_MATRIX;constant I:INTEGER;signal V:CFIXED_VECTOR) is
  begin
    for J in V'range(1) loop
      for K in A'range(3) loop
        if K<V'low(2) then
          A(I,J,K)<='0';           -- zero pad V.RE and V.IM LSBs
        elsif K>V'high(2) then
          A(I,J,K)<=V(J,V'high(2)+K mod 2-1);     -- sign extend V.RE and V.IM MSBs
        else
          A(I,J,K)<=V(J,K);
        end if;
     end loop;
    end loop;
  end;
end TYPES_PKG;