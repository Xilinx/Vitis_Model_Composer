#
# Copyright (C) 2023, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#
# Author: Mark Rollins

ECHO                  := @echo

TARGET                ?= hw_emu

PLATFORM_NAME         ?= vck190_base
PLATFORM_PATH         ?= ${PLATFORM_REPO_PATHS}

PLATFORM              ?= ${PLATFORM_PATH}/${PLATFORM_NAME}/${PLATFORM_NAME}.xpfm
QEMU_PREBUILT         ?= ${YOCTO_ARTIFACTS}/amd-cortexa72-common_vck190_qemu_prebuilt
DISK_IMAGE            ?= ${YOCTO_ARTIFACTS}/amd-cortexa72-common_edf-platform-disk-image

XO                    := ../hls_src/ifft_dma_src/ifft_dma_src_wrapper.xo \
                         ../hls_src/ifft_dma_snk/ifft_dma_snk_wrapper.xo
VSS			          := ../code/vss/DUT/DUT.vss

XSA                   := my.xsa
XCLBIN                := a.xclbin
STIMULUS_IO           := ../data/sig_i.txt ../data/sig_o.txt
PS_EXE                := ../ps_apps/host.exe
EMBEDDED_EXEC         := embedded_exec.sh
RUN_FILES             := ${XCLBIN} host.exe sig_i.txt sig_o.txt ${EMBEDDED_EXEC}

PACKAGE               := $(abspath ../package)
SD_CARD               := ${PACKAGE}/sd_card
BUILD_DIR             := build_${TARGET}

SYSTEM_CFG            := system.cfg

# The design is added to the EDF Linux disk image: BOOT.bin from v++ --package
# replaces boot.bin in the boot partition, and the run files are copied to the
# root partition.
WIC_NAME              := edf-platform-disk-image-amd-cortexa72-common.rootfs
QEMU_WIC              := ${SD_CARD}/${WIC_NAME}.wic.qemu-sd
SD_CARD_IMG           := ${PACKAGE}/sd_card.img
EDF_BOOT_BIN          := ${SD_CARD}/BOOT-versal-vck190-multidomain.bin
WIC_ENV               := ${XILINX_VITIS}/data/emulation/qemu/comp/qemu_edf/environment-setup-x86_64-amdedfsdk-linux
WIC_CP                := wic cp --sector-size=512

.PHONY: clean all package stage_hw_emu stage_hw run_emu

help::
	$(ECHO) "Makefile Usage:"
	$(ECHO) "  make all [TARGET=hw_emu|hw]"
	$(ECHO) "      Link the VSS and data movers to the platform, and package the design for hw_emu or hw"
	$(ECHO) ""
	$(ECHO) "  make run_emu"
	$(ECHO) "      Launch hardware emulation after 'make all TARGET=hw_emu'"
	$(ECHO) ""
	$(ECHO) "  make clean"
	$(ECHO) "      Command to remove all the generated files."

ifeq (${TARGET},hw_emu)
all: package stage_hw_emu
else
all: package stage_hw
endif

${BUILD_DIR}:
	mkdir ${BUILD_DIR}

${BUILD_DIR}/${XSA}: ${XO} ${SYSTEM_CFG} | ${BUILD_DIR}
	cd ${BUILD_DIR} && \
		v++ --link --debug --save-temps \
			--target ${TARGET} \
			--platform ${PLATFORM} \
			$(addprefix --config ../, ${SYSTEM_CFG}) \
			$(addprefix ../, ${XO}) \
			$(addprefix ../, ${VSS}) \
			--output ${XSA} \
			2>&1 | tee vpp_link.log; exit $${PIPESTATUS[0]}

# Package the linked XSA and the VSS into an XCLBIN and a boot image (BOOT.bin).
package: ${BUILD_DIR}/${XSA} ${PS_EXE} ${STIMULUS_IO}
	rm -rf ${PACKAGE}
	mkdir -p ${SD_CARD}
	cd ${BUILD_DIR} && \
		v++ --package --save-temps \
			--target ${TARGET} \
			--platform ${XSA} \
			--package.defer_aie_run \
			--package.out_dir ${SD_CARD} \
			--output ${XCLBIN} \
			$(addprefix ../, ${VSS}) \
			2>&1 | tee vpp_pack.log; exit $${PIPESTATUS[0]}
	cp ${BUILD_DIR}/${XCLBIN} ${SD_CARD}/
	cp ${PS_EXE} ${STIMULUS_IO} ${EMBEDDED_EXEC} ${SD_CARD}/

# hw_emu: add the design to the disk image of the EDF QEMU prebuilt.
stage_hw_emu:
	cd ${BUILD_DIR} && emconfigutil --platform ${XSA} --od ${SD_CARD} --nd 1
	cp -prf ${QEMU_PREBUILT}/. ${SD_CARD}/.
	cp -f ${SD_CARD}/BOOT.bin $$(readlink -f ${EDF_BOOT_BIN})
	bash -c 'set -e; unset LD_LIBRARY_PATH PYTHONHOME PYTHONPATH; source ${WIC_ENV}; \
		${WIC_CP} ${EDF_BOOT_BIN} ${QEMU_WIC}:1/boot.bin; \
		for f in ${RUN_FILES} emconfig.json; do ${WIC_CP} ${SD_CARD}/$$f ${QEMU_WIC}:2; done'

# hw: add the design to a copy of the EDF disk image, to write to the board's SD card.
stage_hw:
	cp -f $$(readlink -f ${DISK_IMAGE}/${WIC_NAME}.wic) ${SD_CARD_IMG}
	bash -c 'set -e; unset LD_LIBRARY_PATH PYTHONHOME PYTHONPATH; source ${WIC_ENV}; \
		${WIC_CP} ${SD_CARD}/BOOT.bin ${SD_CARD_IMG}:1/boot.bin; \
		for f in ${RUN_FILES}; do ${WIC_CP} ${SD_CARD}/$$f ${SD_CARD_IMG}:2; done'

run_emu:
	unset PYTHONHOME PYTHONPATH; \
	${SD_CARD}/launch_hw_emu.sh \
		-qemu-config ${SD_CARD}/combined.qemuboot.conf \
		-login amd-edf -password amd-edf \
		-run-app "mount /dev/mmcblk0p2 /media; cd /media; ./${EMBEDDED_EXEC}" \
		| tee ${PACKAGE}/embedded_run.log; exit $${PIPESTATUS[0]}

clean:
	rm -rf ${PACKAGE} ${BUILD_DIR}
