library verilog;
use verilog.vl_types.all;
entity match_arbiter is
    generic(
        ACTION_WIDTH    : integer := 320
    );
    port(
        wildcard_hit    : in     vl_logic;
        wildcard_miss   : in     vl_logic;
        wildcard_data   : in     vl_logic_vector;
        wildcard_data_vld: in     vl_logic;
        wildcard_wins   : out    vl_logic;
        wildcard_loses  : out    vl_logic;
        flow_entry_src_port: in     vl_logic_vector(7 downto 0);
        flow_entry_vld  : in     vl_logic;
        exact_hit       : in     vl_logic;
        exact_miss      : in     vl_logic;
        exact_data      : in     vl_logic_vector;
        exact_data_vld  : in     vl_logic;
        exact_wins      : out    vl_logic;
        exact_loses     : out    vl_logic;
        result_fifo_wr_en: out    vl_logic;
        result_fifo_din : out    vl_logic_vector;
        reset           : in     vl_logic;
        clk             : in     vl_logic
    );
end match_arbiter;
