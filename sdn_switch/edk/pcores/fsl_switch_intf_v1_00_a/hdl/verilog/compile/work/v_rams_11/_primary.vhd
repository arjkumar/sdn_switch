library verilog;
use verilog.vl_types.all;
entity v_rams_11 is
    generic(
        DWIDTH          : integer := 15;
        AWIDTH          : integer := 6;
        DEPTH           : integer := 64
    );
    port(
        clk             : in     vl_logic;
        we              : in     vl_logic;
        a               : in     vl_logic_vector;
        dpra            : in     vl_logic_vector;
        di              : in     vl_logic_vector;
        spo             : out    vl_logic_vector;
        dpo             : out    vl_logic_vector
    );
end v_rams_11;
