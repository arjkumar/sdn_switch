library verilog;
use verilog.vl_types.all;
entity opl_processor is
    generic(
        NUM_OUTPUT_QUEUES: integer := 8;
        DATA_WIDTH      : integer := 64;
        RESULT_WIDTH    : integer := 328
    );
    port(
        result_fifo_dout: in     vl_logic_vector;
        result_fifo_rd_en: out    vl_logic;
        result_fifo_empty: in     vl_logic;
        in_fifo_ctrl    : in     vl_logic_vector;
        in_fifo_data    : in     vl_logic_vector;
        in_fifo_rd_en   : out    vl_logic;
        in_fifo_empty   : in     vl_logic;
        out_data        : out    vl_logic_vector;
        out_ctrl        : out    vl_logic_vector;
        out_wr          : out    vl_logic;
        out_rdy         : in     vl_logic;
        pkts_dropped    : out    vl_logic_vector;
        clk             : in     vl_logic;
        reset           : in     vl_logic
    );
end opl_processor;
