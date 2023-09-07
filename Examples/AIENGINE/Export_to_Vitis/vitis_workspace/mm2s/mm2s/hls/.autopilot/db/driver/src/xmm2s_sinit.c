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
#include "xmm2s.h"

extern XMm2s_Config XMm2s_ConfigTable[];

#ifdef SDT
XMm2s_Config *XMm2s_LookupConfig(UINTPTR BaseAddress) {
	XMm2s_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XMm2s_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XMm2s_ConfigTable[Index].BaseAddress == BaseAddress) {
			ConfigPtr = &XMm2s_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XMm2s_Initialize(XMm2s *InstancePtr, UINTPTR BaseAddress) {
	XMm2s_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XMm2s_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XMm2s_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XMm2s_Config *XMm2s_LookupConfig(u16 DeviceId) {
	XMm2s_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XMM2S_NUM_INSTANCES; Index++) {
		if (XMm2s_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XMm2s_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XMm2s_Initialize(XMm2s *InstancePtr, u16 DeviceId) {
	XMm2s_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XMm2s_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XMm2s_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

