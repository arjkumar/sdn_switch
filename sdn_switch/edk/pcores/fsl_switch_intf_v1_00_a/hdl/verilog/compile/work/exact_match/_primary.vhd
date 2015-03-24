library verilog;
use verilog.vl_types.all;
entity exact_match is
    generic(
        NUM_OUTPUT_QUEUES: integer := 8;
        PKT_SIZE_WIDTH  : integer := 12;
        SRAM_ADDR_WIDTH : integer := 19;
        DATA_WIDTH      : integer := 64
    );
    port(
        flow_entry      : in     vl_logic_vector(247 downto 0);
        flow_entry_vld  : in     vl_logic;
        pkt_size        : in     vl_logic_vector;
        exact_match_rdy : out    vl_logic;
        exact_hit       : out    vl_logic;
        exact_miss      : out    vl_logic;
        exact_data      : out    vl_logic_vector(319 downto 0);
        exact_data_vld  : out    vl_logic;
        exact_wins      : in     vl_logic;
        exact_loses     : in     vl_logic;
        wr_0_addr       : out    vl_logic_vector;
        wr_0_req        : out    vl_logic;
        wr_0_ack        : in     vl_logic;
        wr_0_data       : out    vl_logic_vector;
        rd_0_ack        : in     vl_logic;
        rd_0_data       : in     vl_logic_vector;
        rd_0_vld        : in     vl_logic;
        rd_0_addr       : out    vl_logic_vector;
        rd_0_req        : out    vl_logic;
        openflow_timer  : in     vl_logic_vector(31 downto 0);
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end exact_match;
