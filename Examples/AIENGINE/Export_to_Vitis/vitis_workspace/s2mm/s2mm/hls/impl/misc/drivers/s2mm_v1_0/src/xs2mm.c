// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.08
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xs2mm.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XS2mm_CfgInitialize(XS2mm *InstancePtr, XS2mm_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XS2mm_Start(XS2mm *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_AP_CTRL) & 0x80;
    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XS2mm_IsDone(XS2mm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XS2mm_IsIdle(XS2mm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XS2mm_IsReady(XS2mm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XS2mm_Continue(XS2mm *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_AP_CTRL) & 0x80;
    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_AP_CTRL, Data | 0x10);
}

void XS2mm_EnableAutoRestart(XS2mm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XS2mm_DisableAutoRestart(XS2mm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_AP_CTRL, 0);
}

void XS2mm_Set_mem(XS2mm *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_MEM_DATA, (u32)(Data));
    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_MEM_DATA + 4, (u32)(Data >> 32));
}

u64 XS2mm_Get_mem(XS2mm *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_MEM_DATA);
    Data += (u64)XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_MEM_DATA + 4) << 32;
    return Data;
}

void XS2mm_Set_size(XS2mm *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_SIZE_DATA, Data);
}

u32 XS2mm_Get_size(XS2mm *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_SIZE_DATA);
    return Data;
}

void XS2mm_InterruptGlobalEnable(XS2mm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_GIE, 1);
}

void XS2mm_InterruptGlobalDisable(XS2mm *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_GIE, 0);
}

void XS2mm_InterruptEnable(XS2mm *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_IER);
    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_IER, Register | Mask);
}

void XS2mm_InterruptDisable(XS2mm *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_IER);
    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_IER, Register & (~Mask));
}

void XS2mm_InterruptClear(XS2mm *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XS2mm_WriteReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_ISR, Mask);
}

u32 XS2mm_InterruptGetEnabled(XS2mm *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_IER);
}

u32 XS2mm_InterruptGetStatus(XS2mm *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XS2mm_ReadReg(InstancePtr->Control_BaseAddress, XS2MM_CONTROL_ADDR_ISR);
}

