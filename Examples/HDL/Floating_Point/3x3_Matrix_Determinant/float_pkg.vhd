library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package fixed_pkg is new IEEE.fixed_generic_pkg
  generic map(fixed_round_style=>IEEE.fixed_float_types.fixed_round,
              fixed_overflow_style=>IEEE.fixed_float_types.fixed_wrap,
              fixed_guard_bits=>2,
              no_warning=>true);
 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package float_pkg is new IEEE.float_generic_pkg
  generic map(float_exponent_width=>8,
              float_fraction_width=>23,
              float_round_style=>IEEE.fixed_float_types.round_zero,
              float_denormalize=>false,
              float_check_error=>true,
              float_guard_bits =>2,
              no_warning=>true,
              fixed_pkg=>IEEE.fixed_pkg);
