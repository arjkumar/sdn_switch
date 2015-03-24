//================= Openflow Entry related fields =============================

`define OPENFLOW_ENTRY_TRANSP_DST_WIDTH           16

`define OPENFLOW_ENTRY_TRANSP_DST_POS             0

`define OPENFLOW_ENTRY_TRANSP_SRC_WIDTH           16

`define OPENFLOW_ENTRY_TRANSP_SRC_POS             16

`define OPENFLOW_ENTRY_IP_PROTO_WIDTH             8

`define OPENFLOW_ENTRY_IP_PROTO_POS               32

`define OPENFLOW_ENTRY_IP_DST_WIDTH               32

`define OPENFLOW_ENTRY_IP_DST_POS                 40

`define OPENFLOW_ENTRY_IP_SRC_WIDTH               32

`define OPENFLOW_ENTRY_IP_SRC_POS                 72

`define OPENFLOW_ENTRY_ETH_TYPE_WIDTH             16

`define OPENFLOW_ENTRY_ETH_TYPE_POS               104

`define OPENFLOW_ENTRY_ETH_DST_WIDTH              48

`define OPENFLOW_ENTRY_ETH_DST_POS                120

`define OPENFLOW_ENTRY_ETH_SRC_WIDTH              48

`define OPENFLOW_ENTRY_ETH_SRC_POS                168

`define OPENFLOW_ENTRY_SRC_PORT_WIDTH             8

`define OPENFLOW_ENTRY_SRC_PORT_POS               216

`define OPENFLOW_ENTRY_IP_TOS_WIDTH               8

`define OPENFLOW_ENTRY_IP_TOS_POS                 224

`define OPENFLOW_ENTRY_VLAN_ID_WIDTH              16

`define OPENFLOW_ENTRY_VLAN_ID_POS                232

`define OPENFLOW_ENTRY_WIDTH                      248



//================= Openflow Actions related fields =============================

// The actionfield is composed of a bitmask specifying actions to take and arguments.
`define OPENFLOW_ACTION_WIDTH                     320

// Ports to forward on
`define OPENFLOW_FORWARD_BITMASK_WIDTH            16

`define OPENFLOW_FORWARD_BITMASK_POS              0

`define OPENFLOW_NF2_ACTION_FLAG_WIDTH            16

`define OPENFLOW_NF2_ACTION_FLAG_POS              16

// Vlan ID to be replaced
`define OPENFLOW_SET_VLAN_VID_WIDTH               16

`define OPENFLOW_SET_VLAN_VID_POS                 32

// Vlan priority to be replaced
`define OPENFLOW_SET_VLAN_PCP_WIDTH               8

`define OPENFLOW_SET_VLAN_PCP_POS                 48

// Source MAC address to be replaced
`define OPENFLOW_SET_DL_SRC_WIDTH                 48

`define OPENFLOW_SET_DL_SRC_POS                   56

// Destination MAC address to be replaced
`define OPENFLOW_SET_DL_DST_WIDTH                 48

`define OPENFLOW_SET_DL_DST_POS                   104

// Source network address to be replaced
`define OPENFLOW_SET_NW_SRC_WIDTH                 32

`define OPENFLOW_SET_NW_SRC_POS                   152

// Destination network address to be replaced
`define OPENFLOW_SET_NW_DST_WIDTH                 32

`define OPENFLOW_SET_NW_DST_POS                   184

// TOS to be replaced
`define OPENFLOW_SET_NW_TOS_WIDTH                 8 

`define OPENFLOW_SET_NW_TOS_POS                   216

// Source transport port to be replaced
`define OPENFLOW_SET_TP_SRC_WIDTH                 16

`define OPENFLOW_SET_TP_SRC_POS                   224

// Destination transport port to be replaced
`define OPENFLOW_SET_TP_DST_WIDTH                 16

`define OPENFLOW_SET_TP_DST_POS                   240

//================= Protocol Ethertypes =============================


`define ETH_TYPE_IP                               'h0800
			
`define ETH_TYPE_ARP                              'h0806

`define IP_PROTO_TCP                              'h06

`define IP_PROTO_UDP                              'h11

`define IP_PROTO_ICMP                             'h01


//================= Exact Match =============================


`define OPENFLOW_EXACT_ENTRY_PKT_COUNTER_WIDTH    25

`define OPENFLOW_EXACT_ENTRY_PKT_COUNTER_POS      0

`define OPENFLOW_EXACT_ENTRY_LAST_SEEN_WIDTH      7

`define OPENFLOW_EXACT_ENTRY_LAST_SEEN_POS        25

`define OPENFLOW_EXACT_ENTRY_BYTE_COUNTER_WIDTH   32

`define OPENFLOW_EXACT_ENTRY_BYTE_COUNTER_POS     32

`define OPENFLOW_EXACT_ENTRY_HDR_BASE_POS         32'h00000000

`define OPENFLOW_EXACT_ENTRY_COUNTERS_POS         32'h00000008

`define OPENFLOW_EXACT_ENTRY_ACTION_BASE_POS      32'h0000000a


//================= Exact Match =============================
`define NF2_OFPAT_OUTPUT                          16'h0001

`define NF2_OFPAT_SET_VLAN_VID                    16'h0002

`define NF2_OFPAT_SET_VLAN_PCP                    16'h0004

`define NF2_OFPAT_STRIP_VLAN                      16'h0008

`define NF2_OFPAT_SET_DL_SRC                      16'h0010

`define NF2_OFPAT_SET_DL_DST                      16'h0020

`define NF2_OFPAT_SET_NW_SRC                      16'h0040

`define NF2_OFPAT_SET_NW_DST                      16'h0080

`define NF2_OFPAT_SET_NW_TOS                      16'h0100

`define NF2_OFPAT_SET_TP_SRC                      16'h0200

`define NF2_OFPAT_SET_TP_DST                      16'h0400



