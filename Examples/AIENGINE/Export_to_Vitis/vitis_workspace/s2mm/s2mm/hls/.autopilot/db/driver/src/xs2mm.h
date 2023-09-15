// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.08
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XS2MM_H
#define XS2MM_H

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
#include "xs2mm_hw.h"

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
} XS2mm_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XS2mm;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XS2mm_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XS2mm_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XS2mm_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XS2mm_ReadReg(BaseAddress, RegOffset) \
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
int XS2mm_Initialize(XS2mm *InstancePtr, UINTPTR BaseAddress);
XS2mm_Config* XS2mm_LookupConfig(UINTPTR BaseAddress);
#else
int XS2mm_Initialize(XS2mm *InstancePtr, u16 DeviceId);
XS2mm_Config* XS2mm_LookupConfig(u16 DeviceId);
#endif
int XS2mm_CfgInitialize(XS2mm *InstancePtr, XS2mm_Config *ConfigPtr);
#else
int XS2mm_Initialize(XS2mm *InstancePtr, const char* InstanceName);
int XS2mm_Release(XS2mm *InstancePtr);
#endif

void XS2mm_Start(XS2mm *InstancePtr);
u32 XS2mm_IsDone(XS2mm *InstancePtr);
u32 XS2mm_IsIdle(XS2mm *InstancePtr);
u32 XS2mm_IsReady(XS2mm *InstancePtr);
void XS2mm_Continue(XS2mm *InstancePtr);
void XS2mm_EnableAutoRestart(XS2mm *InstancePtr);
void XS2mm_DisableAutoRestart(XS2mm *InstancePtr);

void XS2mm_Set_mem(XS2mm *InstancePtr, u64 Data);
u64 XS2mm_Get_mem(XS2mm *InstancePtr);
void XS2mm_Set_size(XS2mm *InstancePtr, u32 Data);
u32 XS2mm_Get_size(XS2mm *InstancePtr);

void XS2mm_InterruptGlobalEnable(XS2mm *InstancePtr);
void XS2mm_InterruptGlobalDisable(XS2mm *InstancePtr);
void XS2mm_InterruptEnable(XS2mm *InstancePtr, u32 Mask);
void XS2mm_InterruptDisable(XS2mm *InstancePtr, u32 Mask);
void XS2mm_InterruptClear(XS2mm *InstancePtr, u32 Mask);
u32 XS2mm_InterruptGetEnabled(XS2mm *InstancePtr);
u32 XS2mm_InterruptGetStatus(XS2mm *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
