/*****************************************************************************
* Filename:          /raid/home/akumar17/thesis/ml410_mb2/edk/drivers/fsl_switch_intf_v1_00_a/src/fsl_switch_intf.h
* Version:           1.00.a
* Description:       fsl_switch_intf (new FSL core) Driver Header File
* Date:              Thu Mar 19 20:57:34 2015 (by Create and Import Peripheral Wizard)
*****************************************************************************/

#ifndef FSL_SWITCH_INTF_H
#define FSL_SWITCH_INTF_H

#include "xstatus.h"


#include "fsl.h" 
#define write_into_fsl(val, id)  putfsl(val, id)
#define read_from_fsl(val, id)  getfsl(val, id)


void fsl_switch_intf(unsigned int input_slot_id, uint32_t * input_0){
	int i;
	   for (i=0; i<3; i++)
	   {
	        //write_into_fsl(input_0[i], input_slot_id);
		    write_into_fsl(input_0[i], 0);
	   }
}

#endif 
