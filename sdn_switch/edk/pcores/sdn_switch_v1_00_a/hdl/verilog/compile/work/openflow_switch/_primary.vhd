library verilog;
use verilog.vl_types.all;
entity openflow_switch is
    generic(
        DATA_WIDTH      : integer := 64;
        UDP_REG_SRC_WIDTH: integer := 2;
        NUM_OUTPUT_QUEUES: integer := 4;
        NUM_INPUT_QUEUES: integer := 4;
        SRAM_ADDR_WIDTH : integer := 9;
        SWITCH_ID       : integer := 0
    );
    port(
        out_data_0      : out    vl_logic_vector;
        out_ctrl_0      : out    vl_logic_vector;
        out_wr_0        : out    vl_logic;
        out_rdy_0       : in     vl_logic;
        out_data_1      : out    vl_logic_vector;
        out_ctrl_1      : out    vl_logic_vector;
        out_wr_1        : out    vl_logic;
        out_rdy_1       : in     vl_logic;
        out_data_2      : out    vl_logic_vector;
        out_ctrl_2      : out    vl_logic_vector;
        out_wr_2        : out    vl_logic;
        out_rdy_2       : in     vl_logic;
        out_data_3      : out    vl_logic_vector;
        out_ctrl_3      : out    vl_logic_vector;
        out_wr_3        : out    vl_logic;
        out_rdy_3       : in     vl_logic;
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
        cpu_in_reg_wr_data_bus: in     vl_logic_vector(59 downto 0);
        cpu_in_reg_ctrl : in     vl_logic_vector(6 downto 0);
        cpu_in_reg_vld  : in     vl_logic;
        cpu_in_reg_rd_data_bus: in     vl_logic_vector(31 downto 0);
        cpu_in_reg_ack  : in     vl_logic;
        cpu_out_reg_wr_data_bus: out    vl_logic_vector(59 downto 0);
        cpu_out_reg_ctrl: out    vl_logic_vector(6 downto 0);
        cpu_out_reg_vld : out    vl_logic;
        cpu_out_reg_rd_data_bus: out    vl_logic_vector(31 downto 0);
        cpu_out_reg_ack : out    vl_logic;
        sram_reset_done : out    vl_logic;
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end openflow_switch;
