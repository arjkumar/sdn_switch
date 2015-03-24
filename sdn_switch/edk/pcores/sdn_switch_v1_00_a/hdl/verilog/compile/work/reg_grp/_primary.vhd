library verilog;
use verilog.vl_types.all;
entity reg_grp is
    generic(
        IDLE            : integer := 0;
        SEND_DATA       : integer := 1;
        SEND_ERROR_DATA : integer := 2
    );
    port(
        switch_reg_wr_data_bus: in     vl_logic_vector(59 downto 0);
        switch_reg_ctrl : in     vl_logic_vector(6 downto 0);
        switch_reg_vld  : in     vl_logic;
        switch_reg_rd_data_bus: out    vl_logic_vector(31 downto 0);
        switch_reg_ack  : out    vl_logic;
        reg_fifo_empty  : out    vl_logic;
        reg_fifo_rd_en  : in     vl_logic;
        reg_rd_wr_L     : out    vl_logic;
        reg_addr        : out    vl_logic_vector(26 downto 0);
        reg_rd_data     : in     vl_logic_vector(31 downto 0);
        reg_wr_data     : out    vl_logic_vector(31 downto 0);
        reg_rd_vld      : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end reg_grp;
