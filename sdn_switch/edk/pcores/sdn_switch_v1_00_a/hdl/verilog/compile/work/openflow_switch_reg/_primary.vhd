library verilog;
use verilog.vl_types.all;
entity openflow_switch_reg is
    generic(
        TIMEOUT         : integer := 127;
      --TIMEOUT_RESULT  : integer type with unrepresentable value!
        SWITCH_ID       : integer := 0
    );
    port(
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
        switch_reg_wr_data_bus: out    vl_logic_vector(59 downto 0);
        switch_reg_ctrl : out    vl_logic_vector(6 downto 0);
        switch_reg_vld  : out    vl_logic;
        switch_reg_rd_data_bus: in     vl_logic_vector(31 downto 0);
        switch_reg_ack  : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end openflow_switch_reg;
