/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* XILINX CONSORTIUM BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * hello_world_final.c / DES_demo.c: simple test application for DES accelerator peripheral
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */


#include <stdio.h>
#include "platform.h"

#include "xaxidma.h"
#include "hdl_dut.h"

/* DES Accelerator Test data */

static char plain_text[256]  __attribute__ ((aligned (32))) = "This is a secret message that must be hidden, no matter what. Wait - what?      ";
static const size_t pt_len = 80;	// this must be a multiple of 4 bytes!
static char cipher_text[256] __attribute__ ((aligned (32)));
static char deciphered_text[256] __attribute__ ((aligned (32)));





/* helper functions */

extern void putnum(unsigned int num);

void print_ciphertext(char *str, size_t len) {
	static char hex[17] = "0123456789abcdef";
	size_t i = 0;
	size_t z = 0;
	unsigned char x;
	char line[68] = {
			0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
			0x20, '-', 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
			0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
			0x0
	};

	while (i < len) {
		z = i & 0x0f;
		x = (unsigned char)str[i];
		if (x < 0x20 || x > 0x7f) {
			line[z] = '.';
		}
		else {
			line[z] = x;
		}
		line[(z << 1) + z + 19] = hex[(x >> 4) & 0x0f];
		line[(z << 1) + z + 20] = hex[x & 0x0f];
		i++;

		if (!(i & 0x0f)) {
			print(line);
			print("\r\n");
		}
	}
	i &= 0x0f;
	if (i > 0) {
		while (i < 0x10) {
			line[i] = ' ';
			line[(i << 1) + i + 19] = ' ';
			line[(i << 1) + i + 20] = ' ';
			i++;
		}
		print(line);
	}
	print("\r\n");
}


void run_DES_test(hdl_dut *DES_inst, XAxiDma *PL_AXI_DMA_Device)
{
	int Status;
	u32 key_LSW;
	u32 key_MSW;
	u32 decrypt;
	u32 key_parity_error;


	print("\r\n Running DES accelerator tests...\r\n");


	/* Test DES_accel AXI-Lite interface memory mapped locations */

	/* Configure the encryption key */
	key_MSW = 0x98674058;
	key_LSW = 0x01645880;
	hdl_dut_key_31_0_write(DES_inst, key_LSW);
	hdl_dut_key_63_32_write(DES_inst, key_MSW);
	decrypt = 0;	// encrypt
	hdl_dut_decrypt_write(DES_inst, decrypt);

	/* Read back the DES configuration */
	key_LSW = hdl_dut_key_31_0_read(DES_inst);
	key_MSW = hdl_dut_key_63_32_read(DES_inst);
	decrypt = hdl_dut_decrypt_read(DES_inst);
	key_parity_error = hdl_dut_parity_err_read(DES_inst);
	print("DES key = 0x");
	putnum(key_MSW);
	putnum(key_LSW);
	print("\r\n");
	if (key_parity_error == 1)
		print("Warning: DES key contains parity errors.\r\n");

	/* Print plain text */
	print("DES plain text input: \r\n");
	print_ciphertext(plain_text, pt_len);


	/* Disable the cache so we will see the results from the DMA transfer */
	Xil_DCacheFlushRange((u32) cipher_text, 256);

	/*
	 * start the DMA transfers
	 */

	Status  = XAxiDma_SimpleTransfer(PL_AXI_DMA_Device, (u32) cipher_text, pt_len, XAXIDMA_DEVICE_TO_DMA);
	Status |= XAxiDma_SimpleTransfer(PL_AXI_DMA_Device, (u32) plain_text,  pt_len, XAXIDMA_DMA_TO_DEVICE);

	if (Status != XST_FAILURE) {
		Status = XAxiDma_ReadReg(PL_AXI_DMA_Device->RegBase + XAXIDMA_TX_OFFSET, XAXIDMA_SR_OFFSET) << 16;
		Status |= XAxiDma_ReadReg(PL_AXI_DMA_Device->RegBase + XAXIDMA_RX_OFFSET, XAXIDMA_SR_OFFSET);
		print("AXI DMA Status = "); putnum(Status); print("\r\n");
		while (XAxiDma_Busy(PL_AXI_DMA_Device, XAXIDMA_DMA_TO_DEVICE) || XAxiDma_Busy(PL_AXI_DMA_Device, XAXIDMA_DEVICE_TO_DMA))
		{
		}
		Status = XAxiDma_ReadReg(PL_AXI_DMA_Device->RegBase + XAXIDMA_TX_OFFSET, XAXIDMA_SR_OFFSET) << 16;
		Status |= XAxiDma_ReadReg(PL_AXI_DMA_Device->RegBase + XAXIDMA_RX_OFFSET, XAXIDMA_SR_OFFSET);
		print("AXI DMA Status = "); putnum(Status); print("\r\n");
	} else {
		return;
	}


	/* Print cipher text */
	print("DES cipher text output: \r\n");
	print_ciphertext(cipher_text, pt_len);

	/* switch mode to decryption */
	decrypt = 1;
	hdl_dut_decrypt_write(DES_inst, decrypt);

	/* Disable the cache so we will see the results from the DMA transfer */
	Xil_DCacheFlushRange((u32) deciphered_text, 256);

	Status  = XAxiDma_SimpleTransfer(PL_AXI_DMA_Device, (u32) deciphered_text, pt_len, XAXIDMA_DEVICE_TO_DMA);
	Status |= XAxiDma_SimpleTransfer(PL_AXI_DMA_Device, (u32) cipher_text,  pt_len, XAXIDMA_DMA_TO_DEVICE);
	if (Status == XST_FAILURE) {
		print("AXI DMA core initialization FAILED\r\n");
		return;
	} else {
		while (XAxiDma_Busy(PL_AXI_DMA_Device, XAXIDMA_DMA_TO_DEVICE) || XAxiDma_Busy(PL_AXI_DMA_Device, XAXIDMA_DEVICE_TO_DMA))
		{
		}
	}

	/* Print deciphered text */
	print("DES deciphered output: \r\n");
	print_ciphertext(deciphered_text, pt_len);

}

int main()
{
	// Device instance variables and configuration pointers
	// a) AXI DMA
	XAxiDma PL_AXI_DMA_Device;
	XAxiDma_Config *AxiDmaCfgPtr;
	// b) DES Accelerator
	hdl_dut DES_inst;

	int Status;
	int i;

	// general platform initialization
	init_platform();

	/*
	 * initialize DES core
	 */
	Status = hdl_dut_Initialize(&DES_inst, XPAR_LAB6_1_0_DEVICE_ID);

	if (Status == XST_FAILURE) {
		print("DES core initialization FAILED\r\n");
		return -1;
	} else {
		print("DES core initialization PASSED\r\n");
	}
	/*
	 * Initialize the DMA Driver
	 */
	AxiDmaCfgPtr = XAxiDma_LookupConfig(XPAR_AXI_DMA_DEVICE_ID);
	Status = XAxiDma_CfgInitialize(&PL_AXI_DMA_Device, AxiDmaCfgPtr);
	if (Status != XST_FAILURE) {
		XAxiDma_IntrDisable(&PL_AXI_DMA_Device, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DEVICE_TO_DMA);
		XAxiDma_IntrDisable(&PL_AXI_DMA_Device, XAXIDMA_IRQ_ALL_MASK, XAXIDMA_DMA_TO_DEVICE);

		// execute test(s)
		for (i = 0; i < 100; i++) {
			run_DES_test(&DES_inst, &PL_AXI_DMA_Device);
		}

	}

	print("DES core - example all done\r\n");
    return 0;
}

