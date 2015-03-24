library verilog;
use verilog.vl_types.all;
entity user_logic is
    generic(
        C_SLV_DWIDTH    : integer := 32;
        C_NUM_REG       : integer := 32
    );
    port(
        clk             : in     vl_logic;
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
        Bus2IP_Clk      : in     vl_logic;
        Bus2IP_Reset    : in     vl_logic;
        Bus2IP_Data     : in     vl_logic_vector;
        Bus2IP_BE       : in     vl_logic_vector;
        Bus2IP_RdCE     : in     vl_logic_vector;
        Bus2IP_WrCE     : in     vl_logic_vector;
        IP2Bus_Data     : out    vl_logic_vector;
        IP2Bus_RdAck    : out    vl_logic;
        IP2Bus_WrAck    : out    vl_logic;
        IP2Bus_Error    : out    vl_logic
    );
end user_logic;
