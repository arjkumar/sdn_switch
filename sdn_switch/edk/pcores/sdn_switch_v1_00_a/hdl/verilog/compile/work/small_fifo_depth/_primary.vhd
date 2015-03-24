library verilog;
use verilog.vl_types.all;
entity small_fifo_depth is
    generic(
        WIDTH           : integer := 72;
        MAX_DEPTH_BITS  : integer := 3
    );
    port(
        din             : in     vl_logic_vector;
        wr_en           : in     vl_logic;
        rd_en           : in     vl_logic;
        dout            : out    vl_logic_vector;
        full            : out    vl_logic;
        nearly_full     : out    vl_logic;
        prog_full       : out    vl_logic;
        empty           : out    vl_logic;
        depth           : out    vl_logic_vector;
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end small_fifo_depth;
