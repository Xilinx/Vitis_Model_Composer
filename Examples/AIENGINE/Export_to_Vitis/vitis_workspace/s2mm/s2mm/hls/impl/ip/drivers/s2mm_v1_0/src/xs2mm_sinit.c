// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.08
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xs2mm.h"

extern XS2mm_Config XS2mm_ConfigTable[];

#ifdef SDT
XS2mm_Config *XS2mm_LookupConfig(UINTPTR BaseAddress) {
	XS2mm_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XS2mm_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XS2mm_ConfigTable[Index].BaseAddress == BaseAddress) {
			ConfigPtr = &XS2mm_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XS2mm_Initialize(XS2mm *InstancePtr, UINTPTR BaseAddress) {
	XS2mm_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XS2mm_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XS2mm_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XS2mm_Config *XS2mm_LookupConfig(u16 DeviceId) {
	XS2mm_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XS2MM_NUM_INSTANCES; Index++) {
		if (XS2mm_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XS2mm_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XS2mm_Initialize(XS2mm *InstancePtr, u16 DeviceId) {
	XS2mm_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XS2mm_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XS2mm_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

