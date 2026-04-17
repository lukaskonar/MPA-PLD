----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT(
    CLK             : IN  STD_LOGIC;
    BTN             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    SW              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
    UART_TXD        : OUT STD_LOGIC
  );
END ENTITY rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
      PORT(
        CLK             : IN  STD_LOGIC;
        DIG_1           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        DIG_2           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        DIG_3           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        DIG_4           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        DP              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
        DOTS            : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
        DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
      );
  END COMPONENT seg_disp_driver;
  
  COMPONENT bcd_counter 
      PORT(
        CLK                 : IN    STD_LOGIC;      -- clock signal
        CE_100HZ            : IN    STD_LOGIC;      -- 100 Hz clock enable
        CNT_RESET           : IN    STD_LOGIC;      -- counter reset
        CNT_ENABLE          : IN    STD_LOGIC;      -- counter enable
        DISP_ENABLE         : IN    STD_LOGIC;      -- enable display update
        CNT_0               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        CNT_1               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        CNT_2               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        CNT_3               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
        LIVE_LED_OUT        : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
  END COMPONENT bcd_counter;
  
  COMPONENT ce_gen 
      GENERIC (
        G_DIV_FACT          : POSITIVE := 50000
      );
      PORT (
        CLK                 : IN  STD_LOGIC;
        SRST                : IN  STD_LOGIC;
        CE                  : IN  STD_LOGIC;
        CE_O                : OUT STD_LOGIC := '0'
      );
  END COMPONENT ce_gen;


COMPONENT btn_in IS
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );
  PORT(
    CLK                 : IN    STD_LOGIC;
    CE                  : IN    STD_LOGIC;
    BTN                 : IN    STD_LOGIC;
    BTN_DEBOUNCED       : OUT   STD_LOGIC;
    BTN_EDGE_POS        : OUT   STD_LOGIC;
    BTN_EDGE_NEG        : OUT   STD_LOGIC;
    BTN_EDGE_ANY        : OUT   STD_LOGIC
  );
END COMPONENT btn_in;

COMPONENT stopwatch_fsm IS
  PORT (
    CLK                 : IN    STD_LOGIC;
    BTN_S_S             : IN    STD_LOGIC;
    BTN_L_C             : IN    STD_LOGIC;
    CNT_RESET           : OUT   STD_LOGIC;
    CNT_ENABLE          : OUT   STD_LOGIC;
    DISP_ENABLE         : OUT   STD_LOGIC
  );
END COMPONENT stopwatch_fsm;

COMPONENT uart_tx
  PORT (
    CLK       : IN  STD_LOGIC; 
    TX_START  : IN  STD_LOGIC; 
    CLK_EN    : IN  STD_LOGIC;  
    DATA_IN   : IN  STD_LOGIC_VECTOR(7 downto 0);     
    TX_BUSY   : OUT STD_LOGIC;     
    UART_TXD  : OUT STD_LOGIC   
  );
  END COMPONENT uart_tx;


  ------------------------------------------------------------------------------
  
  CONSTANT C_CLK_PERIOD         : TIME := 20 ns;


  SIGNAL ce_100Hz               : STD_LOGIC;
  SIGNAL ce_115200bd            : STD_LOGIC;
  SIGNAL cnt_0                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_1                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_2                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_3                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  
  SIGNAL btn_S_S_r              : STD_LOGIC;
  SIGNAL btn_L_C_r              : STD_LOGIC;
  SIGNAL btn_UART               : STD_LOGIC;
  
  SIGNAL cnt_enable_r           : STD_LOGIC;
  SIGNAL disp_enable_r          : STD_LOGIC;
  SIGNAL cnt_reset_r            : STD_LOGIC;
  
  SIGNAL raw_data : STD_LOGIC_VECTOR(7 DOWNTO 0);

  
 

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- display driver
  --
  --       DIG 1       DIG 2       DIG 3       DIG 4
  --                                       L3
  --       -----       -----       -----   o   -----
  --      |     |     |     |  L1 |     |     |     |
  --      |     |     |     |  o  |     |     |     |
  --       -----       -----       -----       -----
  --      |     |     |     |  o  |     |     |     |
  --      |     |     |     |  L2 |     |     |     |
  --       -----  o    -----  o    -----  o    -----  o
  --             DP1         DP2         DP3         DP4
  --
  --------------------------------------------------------------------------------

  seg_disp_driver_i : seg_disp_driver
  PORT MAP(
    CLK                 => CLK,
    DIG_1               => cnt_3,
    DIG_2               => cnt_2,
    DIG_3               => cnt_1,
    DIG_4               => cnt_0,
    DP                  => "0000",
    DOTS                => "000",
    DISP_SEG            => DISP_SEG,
    DISP_DIG            => DISP_DIG
  );
  --------------------------------------------------------------------------------
  -- clock enable generator
  
    ce_gen_i : ce_gen
  GENERIC MAP(
    G_DIV_FACT                  => 500000
  )
  PORT MAP(
    CLK                         => clk,
    SRST                        => '0',
    CE                          => '1',
    CE_O                        => ce_100hz
  );
  
   ce_gen_i_uart : ce_gen
  GENERIC MAP(
    G_DIV_FACT                  => 435
  )
  PORT MAP(
    CLK                         => clk,
    SRST                        => '0',
    CE                          => '1',
    CE_O                        => ce_115200bd 
  );
  --------------------------------------------------------------------------------
  -- button input module
  
   btn_in_1 : btn_in
  GENERIC MAP(
    G_DEB_PERIOD                => 5
  )
  PORT MAP(
    CLK                         => clk,
    CE                          => ce_100hz,
    BTN                         => btn (0),
    BTN_EDGE_POS                => btn_S_S_r
  );
  
  btn_in_2 : btn_in
  GENERIC MAP(
    G_DEB_PERIOD                => 5
  )
  PORT MAP(
    CLK                         => clk,
    CE                          => ce_100hz,
    BTN                         => btn(3),
    BTN_EDGE_POS                => btn_L_C_r
  );
  
 btn_in_3 : btn_in
  GENERIC MAP(
    G_DEB_PERIOD                => 5
  )
  PORT MAP(
    CLK                         => clk,
    CE                          => ce_100hz,
    BTN                         => btn(2),
    BTN_EDGE_POS                => btn_UART
  );
  
  --------------------------------------------------------------------------------
  -- stopwatch module (4-decade BCD counter)
  
  bcd_counter_i : bcd_counter
  PORT MAP(
    CLK                         => clk,
    CE_100HZ                    => ce_100hz,
    CNT_ENABLE                  => cnt_enable_r,
    DISP_ENABLE                 => disp_enable_r,
    --LIVE_LED_OUT                => LED,
    CNT_RESET                   => cnt_reset_r,
    CNT_0                       => cnt_0,
    CNT_1                       => cnt_1,
    CNT_2                       => cnt_2,
    CNT_3                       => cnt_3
  );
  --------------------------------------------------------------------------------
  -- stopwatch control FSM

  stopwatch_fsm_I: stopwatch_fsm 
  PORT MAP(
    CLK                 => clk,
    BTN_S_S             => btn_S_S_r,
    BTN_L_C             => btn_L_C_r,
    CNT_ENABLE          => cnt_enable_r,
    DISP_ENABLE         => disp_enable_r,
    CNT_RESET           => cnt_reset_r
  );
  
    uart_tx_i : uart_tx
  PORT MAP(
    CLK       => clk,
    TX_START  => btn_UART,
    CLK_EN    => ce_115200bd,
    DATA_IN => raw_data,
    TX_BUSY   => LED(0),
    UART_TXD  => uart_txd
  );

raw_data <= x"3" & cnt_1;
LED(7 DOWNTO 1) <= (others => '0');
  --------------------------------------------------------------------------------
  -- LED connection
----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------