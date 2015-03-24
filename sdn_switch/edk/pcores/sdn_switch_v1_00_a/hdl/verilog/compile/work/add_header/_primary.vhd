library verilog;
use verilog.vl_types.all;
entity add_header is
    generic(
        DATA_WIDTH      : integer := 64;
        PORT_NUMBER     : integer := 0
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
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end add_header;
