library verilog;
use verilog.vl_types.all;
entity sram_arbiter is
    generic(
        SRAM_ADDR_WIDTH : integer := 19;
        SRAM_DATA_WIDTH : integer := 36
    );
    port(
        sram_reg_req    : in     vl_logic;
        sram_reg_rd_wr_L: in     vl_logic;
        sram_reg_addr   : in     vl_logic_vector(21 downto 0);
        sram_reg_wr_data: in     vl_logic_vector(31 downto 0);
        sram_reg_ack    : out    vl_logic;
        sram_reg_rd_data: out    vl_logic_vector(31 downto 0);
        wr_0_req        : in     vl_logic;
        wr_0_addr       : in     vl_logic_vector;
        wr_0_data       : in     vl_logic_vector;
        wr_0_ack        : out    vl_logic;
        rd_0_req        : in     vl_logic;
        rd_0_addr       : in     vl_logic_vector;
        rd_0_data       : out    vl_logic_vector;
        rd_0_ack        : out    vl_logic;
        rd_0_vld        : out    vl_logic;
        sram_addr       : out    vl_logic_vector;
        sram_we         : out    vl_logic;
        sram_bw         : out    vl_logic_vector;
        sram_wr_data    : out    vl_logic_vector;
        sram_rd_data    : in     vl_logic_vector;
        sram_tri_en     : out    vl_logic;
        sram_reset_done : out    vl_logic;
        table_flush     : in     vl_logic;
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end sram_arbiter;
