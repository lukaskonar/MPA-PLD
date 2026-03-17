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
    DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
    
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

  ------------------------------------------------------------------------------
  
  CONSTANT C_CLK_PERIOD         : TIME := 20 ns;


  SIGNAL ce_100Hz               : STD_LOGIC;
  SIGNAL cnt_0                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_1                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_2                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_3                  : STD_LOGIC_VECTOR( 3 DOWNTO 0);

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
    DOTS                => "011",
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


  --------------------------------------------------------------------------------
  -- button input module



  --------------------------------------------------------------------------------
  -- stopwatch module (4-decade BCD counter)
  
   bcd_counter_i : bcd_counter
  PORT MAP(
    CLK                         => clk,
    CE_100HZ                    => ce_100hz,
    CNT_ENABLE                  => SW(3),
    DISP_ENABLE                 => SW(0),
    CNT_RESET                   => BTN(3),
    CNT_0                       => cnt_0,
    CNT_1                       => cnt_1,
    CNT_2                       => cnt_2,
    CNT_3                       => cnt_3,
    LIVE_LED_OUT                => LED
  );



  --------------------------------------------------------------------------------
  -- stopwatch control FSM



  --------------------------------------------------------------------------------
  -- LED connection



----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
