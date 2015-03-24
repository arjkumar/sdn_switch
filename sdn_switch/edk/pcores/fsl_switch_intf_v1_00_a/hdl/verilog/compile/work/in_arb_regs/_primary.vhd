library verilog;
use verilog.vl_types.all;
entity in_arb_regs is
    generic(
        DATA_WIDTH      : integer := 64;
        UDP_REG_SRC_WIDTH: integer := 2
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
        state           : in     vl_logic;
        out_wr          : in     vl_logic;
        out_ctrl        : in     vl_logic_vector;
        out_data        : in     vl_logic_vector;
        out_rdy         : in     vl_logic;
        eop             : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end in_arb_regs;
