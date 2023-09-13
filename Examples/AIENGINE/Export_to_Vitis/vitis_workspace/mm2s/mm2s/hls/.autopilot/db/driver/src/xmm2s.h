// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.08
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XMM2S_H
#define XMM2S_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xmm2s_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
#ifdef SDT
    char *Name;
    UINTPTR BaseAddress;
#else
    u16 DeviceId;
#endif
    u64 Control_BaseAddress;
} XMm2s_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XMm2s;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XMm2s_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XMm2s_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XMm2s_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XMm2s_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
#ifdef SDT
int XMm2s_Initialize(XMm2s *InstancePtr, UINTPTR BaseAddress);
XMm2s_Config* XMm2s_LookupConfig(UINTPTR BaseAddress);
#else
int XMm2s_Initialize(XMm2s *InstancePtr, u16 DeviceId);
XMm2s_Config* XMm2s_LookupConfig(u16 DeviceId);
#endif
int XMm2s_CfgInitialize(XMm2s *InstancePtr, XMm2s_Config *ConfigPtr);
#else
int XMm2s_Initialize(XMm2s *InstancePtr, const char* InstanceName);
int XMm2s_Release(XMm2s *InstancePtr);
#endif

void XMm2s_Start(XMm2s *InstancePtr);
u32 XMm2s_IsDone(XMm2s *InstancePtr);
u32 XMm2s_IsIdle(XMm2s *InstancePtr);
u32 XMm2s_IsReady(XMm2s *InstancePtr);
void XMm2s_Continue(XMm2s *InstancePtr);
void XMm2s_EnableAutoRestart(XMm2s *InstancePtr);
void XMm2s_DisableAutoRestart(XMm2s *InstancePtr);

void XMm2s_Set_mem(XMm2s *InstancePtr, u64 Data);
u64 XMm2s_Get_mem(XMm2s *InstancePtr);
void XMm2s_Set_size(XMm2s *InstancePtr, u32 Data);
u32 XMm2s_Get_size(XMm2s *InstancePtr);

void XMm2s_InterruptGlobalEnable(XMm2s *InstancePtr);
void XMm2s_InterruptGlobalDisable(XMm2s *InstancePtr);
void XMm2s_InterruptEnable(XMm2s *InstancePtr, u32 Mask);
void XMm2s_InterruptDisable(XMm2s *InstancePtr, u32 Mask);
void XMm2s_InterruptClear(XMm2s *InstancePtr, u32 Mask);
u32 XMm2s_InterruptGetEnabled(XMm2s *InstancePtr);
u32 XMm2s_InterruptGetStatus(XMm2s *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
