#!/bin/bash
#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#
# Author: Mark Rollins

export XILINX_XRT=/usr

if [ -f emconfig.json ]; then
    export XCL_EMULATION_MODE=hw_emu
fi

./host.exe a.xclbin
