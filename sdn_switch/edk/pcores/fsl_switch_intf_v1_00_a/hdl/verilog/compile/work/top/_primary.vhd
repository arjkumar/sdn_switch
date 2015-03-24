library verilog;
use verilog.vl_types.all;
entity top is
    generic(
        DATA_WIDTH      : integer := 64;
        CTRL_WIDTH      : integer := 8;
        NUM_QUEUES      : integer := 4;
        UDP_REG_SRC_WIDTH: integer := 2;
        IN_ARB_STAGE_NUM: integer := 2
    );
end top;
