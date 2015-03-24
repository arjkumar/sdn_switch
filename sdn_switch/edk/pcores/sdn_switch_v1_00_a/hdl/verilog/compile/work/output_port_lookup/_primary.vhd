library verilog;
use verilog.vl_types.all;
entity output_port_lookup is
    generic(
        DATA_WIDTH      : integer := 64;
        UDP_REG_SRC_WIDTH: integer := 2;
        IO_QUEUE_STAGE_NUM: integer := 255;
        NUM_OUTPUT_QUEUES: integer := 8;
        NUM_IQ_BITS     : integer := 3;
        STAGE_NUM       : integer := 4;
        SRAM_ADDR_WIDTH : integer := 19;
        CPU_QUEUE_NUM   : integer := 0
    );
    port(
        out_data        : out    vl_logic_vector;
        out_ctrl        : out    vl_logic_vector;
        out_wr          : out    vl_logic;
        out_rdy         : in     vl_logic;
        in_data         : in     vl_logic_vector;
        in_ctrl         : in     vl_logic_vector;
        in_wr           : in     vl_logic;
        in_rdy          : out    vl_logic;
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
        wr_0_addr       : out    vl_logic_vector;
        wr_0_req        : out    vl_logic;
        wr_0_ack        : in     vl_logic;
        wr_0_data       : out    vl_logic_vector;
        rd_0_ack        : in     vl_logic;
        rd_0_data       : in     vl_logic_vector;
        rd_0_vld        : in     vl_logic;
        rd_0_addr       : out    vl_logic_vector;
        rd_0_req        : out    vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end output_port_lookup;
