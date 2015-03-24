/*
 * Copyright (c) 2009-2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
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
#include <stdint.h>
#include <stdlib.h>

#include "platform.h"
#include "fsl_switch_intf.h"
#include "xparameters.h"

//void fsl_switch_intf(unsigned int input_slot_id, unsigned int * input_0);
void fsl_switch_intf(unsigned int input_slot_id, uint32_t * input_0);

#define input_slot_id_0   0

void print(char *str);

typedef struct packet_frame{
	//uint32_t data_high;
	uint64_t data;
	uint32_t ctrl;
}Packet_frame;

int main()
{
	init_platform();
	unsigned int slot = input_slot_id_0;
	uint32_t input_0[3];
    Packet_frame *packet;
    packet = (Packet_frame *) malloc(sizeof(Packet_frame)*10);

    print("Hello World.. Writing the packet in a loop\n\r");
	packet[0].data = 0x00248C0179080024ULL;
	packet[1].data = 0x8C01790681002008ULL;
	packet[2].data = 0x08004520003C16DBULL;
	packet[3].data = 0x00003F06CC8AD5E9ULL;
	packet[4].data = 0xAB0A5EB6B88C0557ULL;
	packet[5].data = 0x901F9030937175F5ULL;
	packet[6].data = 0xDBBAA0121628EFE6ULL;
	packet[7].data = 0x0000020405960402ULL;
	packet[8].data = 0x080A59709A082DDEULL;
	packet[9].data = 0x7D72010303060000ULL;

	packet[0].ctrl = 0;
	packet[1].ctrl = 0;
	packet[2].ctrl = 0;
	packet[3].ctrl = 0;
	packet[4].ctrl = 0;
	packet[5].ctrl = 0;
	packet[6].ctrl = 0;
	packet[7].ctrl = 0;
	packet[8].ctrl = 0;
	packet[9].ctrl = 4;


    int   idx;
    int packet_cnt = 0;

    while(1){
    	for(idx=0;idx<10;idx++){
    	  packet_cnt = packet_cnt + 1;
    	  input_0[0] = packet[idx].ctrl;
    	  input_0[1] = packet[idx].data >> 32;
    	  input_0[2] = packet[idx].data;
    	  //Call the macro with instance specific slot IDs
    	  //xil_printf("Sending Packet %0d - %0X %0H %0H",packet_cnt,input_0[0],input_0[1],input_0[2]);
    	  fsl_switch_intf( slot, input_0 );
    	}
    }

    //Initialize your input data over here:





    return 0;
}