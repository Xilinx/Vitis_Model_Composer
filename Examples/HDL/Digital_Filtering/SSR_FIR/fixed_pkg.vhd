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
use IEEE.STD_LOGIC_1164.all;

package fixed_pkg is new IEEE.fixed_generic_pkg
  generic map(fixed_round_style=>IEEE.fixed_float_types.fixed_truncate,
              fixed_overflow_style=>IEEE.fixed_float_types.fixed_wrap,
              fixed_guard_bits=>2,
              no_warning=>true);
