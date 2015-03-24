library verilog;
use verilog.vl_types.all;
entity fsl_switch_intf is
    generic(
        DATA_WIDTH      : integer := 64;
        CTRL_WIDTH      : integer := 8;
        BACK_PRESS_EN   : integer := 1
    );
    port(
        debug_data      : out    vl_logic_vector(241 downto 0);
        debug_trig      : out    vl_logic_vector(3 downto 0);
        in_rdy          : in     vl_logic;
        out_wr          : out    vl_logic;
        out_data        : out    vl_logic_vector;
        out_ctrl        : out    vl_logic_vector;
        FSL_Clk         : in     vl_logic;
        FSL_Rst         : in     vl_logic;
        FSL_S_Clk       : in     vl_logic;
        FSL_S_Read      : out    vl_logic;
        FSL_S_Data      : in     vl_logic_vector(0 to 31);
        FSL_S_Control   : in     vl_logic;
        FSL_S_Exists    : in     vl_logic
    );
end fsl_switch_intf;
