library verilog;
use verilog.vl_types.all;
entity user_logic is
    generic(
        DATA_WIDTH      : integer := 64;
        CTRL_WIDTH      : integer := 8;
        UDP_REG_SRC_WIDTH: integer := 2;
        IN_ARB_STAGE_NUM: integer := 2;
        NUM_QUEUES      : integer := 4;
        NUM_IQ_BITS     : integer := 2;
        CPU_FLAG_WAIT   : integer := 0;
        READ_THE_PACKET : integer := 1;
        C_SLV_DWIDTH    : integer := 32;
        C_NUM_REG       : integer := 32
    );
    port(
        debug_op_data   : out    vl_logic_vector(73 downto 0);
        debug_op_trig   : out    vl_logic;
        chipscope_en    : in     vl_logic;
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
