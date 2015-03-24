library verilog;
use verilog.vl_types.all;
entity vlan_adder is
    generic(
        DATA_WIDTH      : integer := 64
    );
    port(
        in_data         : in     vl_logic_vector;
        in_ctrl         : in     vl_logic_vector;
        in_wr           : in     vl_logic;
        in_rdy          : out    vl_logic;
        out_data        : out    vl_logic_vector;
        out_ctrl        : out    vl_logic_vector;
        out_wr          : out    vl_logic;
        out_rdy         : in     vl_logic;
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end vlan_adder;
