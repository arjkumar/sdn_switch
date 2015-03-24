library verilog;
use verilog.vl_types.all;
entity input_arbiter is
    generic(
        DATA_WIDTH      : integer := 64;
        UDP_REG_SRC_WIDTH: integer := 2;
        STAGE_NUMBER    : integer := 2;
        NUM_QUEUES      : integer := 4
    );
    port(
        out_data        : out    vl_logic_vector;
        out_ctrl        : out    vl_logic_vector;
        out_wr          : out    vl_logic;
        out_rdy         : in     vl_logic;
        in_data_0       : in     vl_logic_vector;
        in_ctrl_0       : in     vl_logic_vector;
        in_wr_0         : in     vl_logic;
        in_rdy_0        : out    vl_logic;
        in_data_1       : in     vl_logic_vector;
        in_ctrl_1       : in     vl_logic_vector;
        in_wr_1         : in     vl_logic;
        in_rdy_1        : out    vl_logic;
        in_data_2       : in     vl_logic_vector;
        in_ctrl_2       : in     vl_logic_vector;
        in_wr_2         : in     vl_logic;
        in_rdy_2        : out    vl_logic;
        in_data_3       : in     vl_logic_vector;
        in_ctrl_3       : in     vl_logic_vector;
        in_wr_3         : in     vl_logic;
        in_rdy_3        : out    vl_logic;
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
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end input_arbiter;
