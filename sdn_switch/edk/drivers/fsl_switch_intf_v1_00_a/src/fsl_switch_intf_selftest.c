/*****************************************************************************
* Filename:          /raid/home/akumar17/thesis/ml410_mb2/edk/drivers/fsl_switch_intf_v1_00_a/src/fsl_switch_intf_selftest.c
* Version:           1.00.a
* Description:       
* Date:              Thu Mar 19 20:57:34 2015 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#include "xparameters.h"
#include "fsl_switch_intf.h"

/* IMPORTANT:
*  In order to run this self test, you need to modify the value of following
*  micros according to the slot ID defined in xparameters.h file. 
*/
#define input_slot_id   XPAR_FSL_FSL_SWITCH_INTF_0_INPUT_SLOT_ID
XStatus FSL_SWITCH_INTF_SelfTest()
{
	 unsigned int input_0[3];     

	 //Initialize your input data over here: 
	 input_0[0] = 12345;     
	 input_0[1] = 24690;     
	 input_0[2] = 37035;     

	 //Call the macro with instance specific slot IDs
	 fsl_switch_intf(
		 input_slot_id,
		 input_0    
		 );


	 return XST_SUCCESS;
}
