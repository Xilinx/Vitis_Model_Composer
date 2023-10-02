library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use IEEE.MATH_COMPLEX.all;

package cfloat_pkg is 
  use work.float_pkg.all; -- VHDL-2008 float_pkg with no denormalize, rounding to zero, no warning messages
                          -- this gives us FLOAT32, operators and conversion functions
  constant PI:REAL:=3.1415926535897932;
--  type BOOLEAN_VECTOR is array(NATURAL range <>) of BOOLEAN;
--  type INTEGER_VECTOR is array(INTEGER range <>) of INTEGER;
  type STRING_VECTOR is array(INTEGER range <>) of STRING;
  type COMPLEX_VECTOR is array(INTEGER range <>) of COMPLEX;
  type UNSIGNED_VECTOR is array(INTEGER range <>) of UNSIGNED;

-- FLOAT is now the standard VHDL-2008 type defined in float_generic_pkg, we do not need a user defined type anymore but this is what FLOAT really is
--  type FLOAT is array (INTEGER range <>) of STD_LOGIC; -- arbitrary precision floating point number
--  subtype FLOAT32 is FLOAT(8 downto -23);
  type FLOAT32_VECTOR is array(INTEGER range <>) of FLOAT32; -- unconstrained array of FLOAT32
  type FLOAT32_MATRIX is array(INTEGER range <>) of FLOAT32_VECTOR; -- unconstrained array of FLOAT32_VECTOR
  type CFLOAT32 is record RE,IM:FLOAT32; end record; -- single precision floating point complex number
  type CFLOAT32_VECTOR is array(INTEGER range <>) of CFLOAT32; -- unconstrained array of CFLOAT32
  type STD_LOGIC_MATRIX is array(INTEGER range <>) of STD_LOGIC_VECTOR; -- unconstrained array of STD_LOGIC_VECTOR
  type CFLOAT32_MATRIX is array(INTEGER range <>) of CFLOAT32_VECTOR; -- unconstrained array of CFLOAT32_VECTOR
  type COMPLEX_MATRIX is array(INTEGER range <>) of COMPLEX_VECTOR;

  function MIN(A,B:INTEGER) return INTEGER;
  function MIN(A,B,C:INTEGER) return INTEGER;
  function MIN(A,B,C,D:INTEGER) return INTEGER;
  function MAX(A,B:INTEGER) return INTEGER;
  function MAX(A,B,C:INTEGER) return INTEGER;
  function MAX(A,B,C,D:INTEGER) return INTEGER;
  function MED(A,B,C:INTEGER) return INTEGER;

  function "+"(X,Y:CFLOAT32) return CFLOAT32;
  function "-"(X,Y:CFLOAT32) return CFLOAT32;
  function "*"(X,Y:CFLOAT32) return CFLOAT32;
  function "*"(X:CFLOAT32;Y:FLOAT32) return CFLOAT32;
  function "*"(X:FLOAT32;Y:CFLOAT32) return CFLOAT32;
  function PLUS_i_TIMES(X:CFLOAT32) return CFLOAT32;
  function "-"(X:CFLOAT32) return CFLOAT32;
  function MINUS_i_TIMES(X:CFLOAT32) return CFLOAT32;
  function X_PLUS_i_TIMES_Y(X,Y:CFLOAT32) return CFLOAT32;
  function X_MINUS_i_TIMES_Y(X,Y:CFLOAT32) return CFLOAT32;
  function SWAP(X:CFLOAT32) return CFLOAT32;
  function CONJ(X:CFLOAT32) return CFLOAT32;

  function TO_CFLOAT32(R,I:REAL) return CFLOAT32;
  function TO_CFLOAT32(C:COMPLEX) return CFLOAT32;
  function TO_CFLOAT32(R,I:FLOAT32) return CFLOAT32;
  function TO_COMPLEX(C:CFLOAT32) return COMPLEX;
  function TO_CFLOAT32_VECTOR(C:COMPLEX_VECTOR) return CFLOAT32_VECTOR;
  function TO_COMPLEX_VECTOR(C:CFLOAT32_VECTOR) return COMPLEX_VECTOR;
  function "*"(R:REAL;C:COMPLEX_VECTOR) return COMPLEX_VECTOR;
  function LOG2(N:INTEGER) return INTEGER; -- returns ceil(log2(N))
--  function ZERO(U:UNSIGNED) return UNSIGNED; -- returns 0 with the same range as U
--  function ZERO(S:FLOAT32) return FLOAT32; -- returns 0 with the same range as S
--  function ZERO(C:CFLOAT32) return CFLOAT32; -- returns 0 with the same range as C
--  function ZERO(SV:FLOAT32_VECTOR) return FLOAT32_VECTOR; -- returns 0 with the same range as SV
--  function ZERO(CV:CFLOAT32_VECTOR) return CFLOAT32_VECTOR; -- returns 0 with the same range as CV
end package cfloat_pkg;

package body cfloat_pkg is
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
  
  function "+"(X,Y:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(X.RE+Y.RE,X.IM+Y.IM);
  end;
  
  function "-"(X,Y:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(X.RE-Y.RE,X.IM-Y.IM);
  end;
  
  function "*"(X,Y:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(X.RE*Y.RE-X.IM*Y.IM,X.RE*Y.IM+X.IM*Y.RE);
  end;

  function "*"(X:CFLOAT32;Y:FLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(X.RE*Y,X.IM*Y);
  end;

  function "*"(X:FLOAT32;Y:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(X*Y.RE,X*Y.IM);
  end;

  function PLUS_i_TIMES(X:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(-X.IM,X.RE);
  end;
  
  function "-"(X:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(-X.RE,-X.IM);
  end;
  
  function MINUS_i_TIMES(X:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(X.IM,-X.RE);
  end;
  
  function X_PLUS_i_TIMES_Y(X,Y:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(X.RE-Y.IM,X.IM+Y.RE);
  end;
  
  function X_MINUS_i_TIMES_Y(X,Y:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(X.RE+Y.IM,X.IM-Y.RE);
  end;
  
  function SWAP(X:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(X.IM,X.RE);
  end;
  
  function CONJ(X:CFLOAT32) return CFLOAT32 is
  begin
    return TO_CFLOAT32(X.RE,-X.IM);
  end;
  
  function TO_CFLOAT32(R,I:REAL) return CFLOAT32 is
  begin
    return TO_CFLOAT32(TO_FLOAT(R),TO_FLOAT(I));
  end;
  
  function TO_CFLOAT32(C:COMPLEX) return CFLOAT32 is
  begin
    return TO_CFLOAT32(C.RE,C.IM);
  end;
  
  function TO_CFLOAT32(R,I:FLOAT32) return CFLOAT32 is
    variable C:CFLOAT32;
  begin
    C.RE:=R;
    C.IM:=I;
    return C;
  end;

  function TO_COMPLEX(C:CFLOAT32) return COMPLEX is
    variable R:COMPLEX;
  begin
    R.RE:=TO_REAL(C.RE);
    R.IM:=TO_REAL(C.IM);
    return R;
  end;
  
  function TO_CFLOAT32_VECTOR(C:COMPLEX_VECTOR) return CFLOAT32_VECTOR is
    variable R:CFLOAT32_VECTOR(C'range);
  begin
    for K in C'range loop
      R(K):=TO_CFLOAT32(C(K));
    end loop;
    return R;
  end;

  function TO_COMPLEX_VECTOR(C:CFLOAT32_VECTOR) return COMPLEX_VECTOR is
    variable R:COMPLEX_VECTOR(C'range);
  begin
    for K in C'range loop
      R(K):=TO_COMPLEX(C(K));
    end loop;
    return R;
  end;

  function "*"(R:REAL;C:COMPLEX_VECTOR) return COMPLEX_VECTOR is
    variable X:COMPLEX_VECTOR(C'range);
  begin
    for K in C'range loop
      X(K):=R*C(K);
    end loop;
    return X;
  end;

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
/*
  function ZERO(U:UNSIGNED) return UNSIGNED is -- returns 0 with the same range as S
  begin
    return TO_UNSIGNED(0,U'length); 
  end; 

  function ZERO(S:FLOAT32) return FLOAT32 is -- returns 0 with the same range as S
    variable RESULT:FLOAT32:=(others=>'0');
  begin
    return RESULT; 
  end; 

  function ZERO(C:CFLOAT32) return CFLOAT32 is -- returns 0 with the same range as C
  begin
    return TO_CFLOAT32(0.0,0.0); 
  end; 

  function ZERO(SV:FLOAT32_VECTOR) return FLOAT32_VECTOR is -- returns 0 with the same range as SV
    variable RESULT:FLOAT32_VECTOR(SV'range);
  begin
    for K in SV'range loop
      RESULT(K):=(others=>'0'); 
    end loop;
    return RESULT; 
  end; 

  function ZERO(CV:CFLOAT32_VECTOR) return CFLOAT32_VECTOR is -- returns 0 with the same range as CV
    variable RESULT:CFLOAT32_VECTOR(CV'range);
  begin
    for K in CV'range loop
      RESULT(K):=TO_CFLOAT32(0.0,0.0); 
    end loop;
    return RESULT; 
  end; 
*/
end package body cfloat_pkg;