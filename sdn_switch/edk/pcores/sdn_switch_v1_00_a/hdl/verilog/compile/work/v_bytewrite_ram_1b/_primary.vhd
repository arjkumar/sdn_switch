library verilog;
use verilog.vl_types.all;
entity v_bytewrite_ram_1b is
    generic(
        SIZE            : integer := 1024;
        ADDR_WIDTH      : integer := 10;
        COL_WIDTH       : integer := 9;
        NB_COL          : integer := 4
    );
    port(
        clk             : in     vl_logic;
        we              : in     vl_logic_vector;
        rd_addr         : in     vl_logic_vector;
        wr_addr         : in     vl_logic_vector;
        di              : in     vl_logic_vector;
        do              : out    vl_logic_vector
    );
end v_bytewrite_ram_1b;
