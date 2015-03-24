library verilog;
use verilog.vl_types.all;
entity egress_demux is
    generic(
        DATA_WIDTH      : integer := 64;
        UDP_REG_SRC_WIDTH: integer := 2;
        NUM_OUTPUT_QUEUES: integer := 8
    );
    port(
        out_data_0      : out    vl_logic_vector;
        out_ctrl_0      : out    vl_logic_vector;
        out_rdy_0       : in     vl_logic;
        out_wr_0        : out    vl_logic;
        out_data_1      : out    vl_logic_vector;
        out_ctrl_1      : out    vl_logic_vector;
        out_rdy_1       : in     vl_logic;
        out_wr_1        : out    vl_logic;
        out_data_2      : out    vl_logic_vector;
        out_ctrl_2      : out    vl_logic_vector;
        out_rdy_2       : in     vl_logic;
        out_wr_2        : out    vl_logic;
        out_data_3      : out    vl_logic_vector;
        out_ctrl_3      : out    vl_logic_vector;
        out_rdy_3       : in     vl_logic;
        out_wr_3        : out    vl_logic;
        in_data         : in     vl_logic_vector;
        in_ctrl         : in     vl_logic_vector;
        in_rdy          : out    vl_logic;
        in_wr           : in     vl_logic;
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
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end egress_demux;
