##############################################################################
## Filename:          /raid/home/akumar17/thesis/sdn_switch/edk/drivers/sdn_ctlr_intf_v1_00_a/data/sdn_ctlr_intf_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Sat Mar 21 20:01:44 2015 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "sdn_ctlr_intf" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
