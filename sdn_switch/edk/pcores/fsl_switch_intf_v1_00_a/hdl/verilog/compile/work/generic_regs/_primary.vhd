library verilog;
use verilog.vl_types.all;
entity generic_regs is
    generic(
        UDP_REG_SRC_WIDTH: integer := 2;
        TAG             : integer := 0;
        REG_ADDR_WIDTH  : integer := 5;
        NUM_COUNTERS    : integer := 8;
        NUM_SOFTWARE_REGS: integer := 8;
        NUM_HARDWARE_REGS: integer := 8;
        NUM_INSTANCES   : integer := 1;
        COUNTER_INPUT_WIDTH: integer := 1;
        MIN_UPDATE_INTERVAL: integer := 8;
        COUNTER_WIDTH   : integer := 32;
        RESET_ON_READ   : integer := 0;
        REG_START_ADDR  : integer := 0;
        ACK_UNFOUND_ADDRESSES: integer := 1;
        REVERSE_WORD_ORDER: integer := 0
    );
    port(
        reg_req_in      : in     vl_logic;
        reg_ack_in      : in     vl_logic;
        reg_rd_wr_L_in  : in     vl_logic;
        reg_addr_in     : in     vl_logic_vector(22 downto 0);
        reg_data_in     : in     vl_logic_vector(31 downto 0);
        reg_src_in      : in     vl_logic_vector;
        reg_req_out     : out    vl_logic;
        reg_ack_out     : out    vl_logic;
        reg_rd_wr_L_out : out    vl_logic;
        reg_addr_out    : out    vl_logic_vector(22 downto 0);
        reg_data_out    : out    vl_logic_vector(31 downto 0);
        reg_src_out     : out    vl_logic_vector;
        counter_updates : in     vl_logic_vector;
        counter_decrement: in     vl_logic_vector;
        software_regs   : out    vl_logic_vector;
        hardware_regs   : in     vl_logic_vector;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end generic_regs;
