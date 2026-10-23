#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#
# Author: Mark Rollins

ECHO                               = @echo
export TARGET                      ?= hw_emu

RELEASE=2026.2

TOP_DIR                   ?= $(shell readlink -f .)
PLATFORM_NAME              = vck190_base
PLATFORM_PATH              = ${PLATFORM_REPO_PATHS}

export PLATFORM            = ${PLATFORM_PATH}/${PLATFORM_NAME}/${PLATFORM_NAME}.xpfm
export SYSROOT             = ${YOCTO_ARTIFACTS}/amd-cortexa72-common_meta-edf-app-sdk/sdk/sysroots/cortexa72-cortexa53-amd-linux
export QEMU_PREBUILT       = ${YOCTO_ARTIFACTS}/amd-cortexa72-common_vck190_qemu_prebuilt

##############
# Build Flow #
##############
.PHONY: clean help check_env run_emu

help::
	$(ECHO) "Makefile Usage:"
	$(ECHO) "  make all [TARGET=hw_emu|hw]"
	$(ECHO) "      Command to generate everything for this design"
	$(ECHO) ""
	$(ECHO) "  make run_emu"
	$(ECHO) "      Command to launch hardware emulation after 'make all TARGET=hw_emu'"
	$(ECHO) ""
	$(ECHO) "  make clean"
	$(ECHO) "      Command to remove all the generated files."

all:	check_env ifft

check_env:
ifndef YOCTO_ARTIFACTS
	$(error YOCTO_ARTIFACTS is not set. Set it to the folder that contains the EDF Yocto artifacts)
endif
ifndef PLATFORM_REPO_PATHS
	$(error PLATFORM_REPO_PATHS is not set. Set it to the base_platforms folder of the Vitis installation)
endif

ifft:
	$(MAKE) all -C hls_src/ifft_dma_src
	$(MAKE) all -C hls_src/ifft_dma_snk
	$(MAKE) all -C ps_apps
	$(MAKE) all -C vitis

run_emu:
	$(MAKE) run_emu -C vitis

clean:
	$(MAKE) clean -C hls_src/ifft_dma_src
	$(MAKE) clean -C hls_src/ifft_dma_snk
	$(MAKE) clean -C ps_apps
	$(MAKE) clean -C vitis
	@/bin/rm -rf .crashReporter*
