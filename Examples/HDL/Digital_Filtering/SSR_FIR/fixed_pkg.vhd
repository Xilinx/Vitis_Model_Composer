--
-- Copyright © Advanced Micro Devices, Inc., or its affiliates.
--
-- SPDX-License-Identifier: MIT
--
-- Portions of this content consists of AI generated content.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package fixed_pkg is new IEEE.fixed_generic_pkg
  generic map(fixed_round_style=>IEEE.fixed_float_types.fixed_truncate,
              fixed_overflow_style=>IEEE.fixed_float_types.fixed_wrap,
              fixed_guard_bits=>2,
              no_warning=>true);
