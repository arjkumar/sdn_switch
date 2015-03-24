library verilog;
use verilog.vl_types.all;
entity header_parser is
    generic(
        DATA_WIDTH      : integer := 64;
        PKT_SIZE_WIDTH  : integer := 12;
        ADDITIONAL_WORD_SIZE: integer := 16;
        ADDITIONAL_WORD_BITMASK: integer := 4095;
        ADDITIONAL_WORD_POS: integer := 224;
        ADDITIONAL_WORD_CTRL: integer := 64;
        ADDITIONAL_WORD_DEFAULT: integer := 65535;
        FLOW_ENTRY_SIZE : integer := 240
    );
    port(
        in_data         : in     vl_logic_vector;
        in_ctrl         : in     vl_logic_vector;
        in_wr           : in     vl_logic;
        flow_entry      : out    vl_logic_vector;
        flow_entry_src_port: out    vl_logic_vector(7 downto 0);
        pkt_size        : out    vl_logic_vector;
        flow_entry_vld  : out    vl_logic;
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end header_parser;
