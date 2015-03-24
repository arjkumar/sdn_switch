library verilog;
use verilog.vl_types.all;
entity generic_hw_regs is
    generic(
        UDP_REG_SRC_WIDTH: integer := 2;
        TAG             : integer := 0;
        REG_ADDR_WIDTH  : integer := 5;
        NUM_REGS_USED   : integer := 8;
        REG_START_ADDR  : integer := 0
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
        hardware_regs   : in     vl_logic_vector;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end generic_hw_regs;
