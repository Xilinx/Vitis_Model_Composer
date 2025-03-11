#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#
# Author: Mark Rollins

ECHO                  := @echo

TARGET                ?= hw_emu

PLATFORM_NAME              ?= xilinx_vck190_base_202420_1
PLATFORM_PATH              ?= ${PLATFORM_REPO_PATHS}

PLATFORM            ?= ${PLATFORM_PATH}/${PLATFORM_NAME}/${PLATFORM_NAME}.xpfm
SYSROOT             ?= ${COMMON_IMAGE_VERSAL}/sysroots/cortexa72-cortexa53-xilinx-linux
KERNEL_IMAGE        ?= ${COMMON_IMAGE_VERSAL}/Image
ROOTFS              ?= ${COMMON_IMAGE_VERSAL}/rootfs.ext4
PREBUILT_LINUX_PATH ?= ${COMMON_IMAGE_VERSAL}

XO                    := ../hls_src/ifft_dma_src/ifft_dma_src_wrapper.xo \
                         ../hls_src/ifft_dma_snk/ifft_dma_snk_wrapper.xo
VSS			          := ../code/vss/DUT/DUT.vss

XSA                   := my.xsa
STIMULUS_IO           := ../data/sig_i.txt ../data/sig_o.txt
PS_EXE                := ../ps_apps/host.exe

SD_CARD               := $(abspath ../package)
BUILD_DIR             := build_${TARGET}

SYSTEM_CFG            := system.cfg

.PHONY: clean all

help::
	$(ECHO) "Makefile Usage:"
	$(ECHO) "  make all"
	$(ECHO) "      Command to generate the sd_card in this design, including platform/petalinux/ip/ps_apps"
	$(ECHO) ""
	$(ECHO) "  make clean"
	$(ECHO) "      Command to remove all the generated files."

all: ${BUILD_DIR} ${BUILD_DIR}/${XSA} ${SD_CARD}

${BUILD_DIR}:
	mkdir ${BUILD_DIR}

${BUILD_DIR}/${XSA}: ${XO} ${SYSTEM_CFG}
	cd ${BUILD_DIR} && \
		v++ --link --debug --save-temps \
			--target ${TARGET} \
			--platform ${PLATFORM} \
			$(addprefix --config ../, ${SYSTEM_CFG}) \
			$(addprefix ../, ${XO}) \
            $(addprefix ../, ${VSS}) \
			--output ${XSA} \
			2>&1 | tee vpp_link.log

${SD_CARD}: ${BUILD_DIR}/${XSA} ${PS_EXE} ${KERNEL_IMAGE} ${ROOTFS} ${STIMULUS_IO}
	cd ${BUILD_DIR} && \
		v++ --package --debug --save-temps \
			--target ${TARGET} \
			--platform ${PLATFORM} \
			--package.out_dir ${SD_CARD} \
			--package.boot_mode=sd \
			--package.image_format=ext4 \
			--package.kernel_image=${KERNEL_IMAGE} \
			--package.rootfs=${ROOTFS}  \
			--package.defer_aie_run \
            ${XSA} \
            $(addprefix ../, ${VSS}) \
			$(addprefix --package.sd_file=../, ${PS_EXE}) \
			$(addprefix --package.sd_file=../,${STIMULUS_IO}) \
			$(addprefix --package.sd_file=../,embedded_exec.sh) \
			2>&1 | tee vpp_pack.log
	echo ${PLATFORM_CUSTOM} > ${SD_CARD}/sd_card/platform_desc.txt

clean:
	rm -rf ${SD_CARD} ${BUILD_DIR}

