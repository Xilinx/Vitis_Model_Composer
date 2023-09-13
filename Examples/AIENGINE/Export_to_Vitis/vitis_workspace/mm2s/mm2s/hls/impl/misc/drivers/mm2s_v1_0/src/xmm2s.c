// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.08
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xmm2s.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XMm2s_CfgInitialize(XMm2s *InstancePtr, XMm2s_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XMm2s_Start(XMm2s *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_AP_CTRL) & 0x80;
    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XMm2s_IsDone(XMm2s *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XMm2s_IsIdle(XMm2s *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XMm2s_IsReady(XMm2s *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XMm2s_Continue(XMm2s *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_AP_CTRL) & 0x80;
    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_AP_CTRL, Data | 0x10);
}

void XMm2s_EnableAutoRestart(XMm2s *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XMm2s_DisableAutoRestart(XMm2s *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_AP_CTRL, 0);
}

void XMm2s_Set_mem(XMm2s *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_MEM_DATA, (u32)(Data));
    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_MEM_DATA + 4, (u32)(Data >> 32));
}

u64 XMm2s_Get_mem(XMm2s *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_MEM_DATA);
    Data += (u64)XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_MEM_DATA + 4) << 32;
    return Data;
}

void XMm2s_Set_size(XMm2s *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_SIZE_DATA, Data);
}

u32 XMm2s_Get_size(XMm2s *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_SIZE_DATA);
    return Data;
}

void XMm2s_InterruptGlobalEnable(XMm2s *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_GIE, 1);
}

void XMm2s_InterruptGlobalDisable(XMm2s *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_GIE, 0);
}

void XMm2s_InterruptEnable(XMm2s *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_IER);
    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_IER, Register | Mask);
}

void XMm2s_InterruptDisable(XMm2s *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_IER);
    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_IER, Register & (~Mask));
}

void XMm2s_InterruptClear(XMm2s *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMm2s_WriteReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_ISR, Mask);
}

u32 XMm2s_InterruptGetEnabled(XMm2s *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_IER);
}

u32 XMm2s_InterruptGetStatus(XMm2s *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XMm2s_ReadReg(InstancePtr->Control_BaseAddress, XMM2S_CONTROL_ADDR_ISR);
}

