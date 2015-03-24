library verilog;
use verilog.vl_types.all;
entity header_hash is
    generic(
        INPUT_WIDTH     : integer := 240;
        OUTPUT_WIDTH    : integer := 19
    );
    port(
        data            : in     vl_logic_vector;
        hash_0          : out    vl_logic_vector;
        hash_1          : out    vl_logic_vector;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end header_hash;
