library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------------
entity uart_tx_tb is
end uart_tx_tb;
----------------------------------------------------------------------------------

architecture Behavioral of uart_tx_tb is
----------------------------------------------------------------------------------

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

  --------------------------------------------------------------------------------
  -- Konstanty a signály
  --------------------------------------------------------------------------------
  CONSTANT C_CLK_PERIOD       : TIME := 20 ns;
  SIGNAL simulation_finished  : BOOLEAN := FALSE;

  -- Signály pro propojení s komponentou
  SIGNAL clk       : STD_LOGIC := '0';
  SIGNAL tx_start  : STD_LOGIC := '0';
  SIGNAL clk_en    : STD_LOGIC := '0';
  SIGNAL data_in   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
  SIGNAL tx_busy   : STD_LOGIC;
  SIGNAL uart_txd  : STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  -- Generátor hodin
  proc_clk_gen: PROCESS BEGIN
    clk <= '0'; WAIT FOR C_CLK_PERIOD/2;
    clk <= '1'; WAIT FOR C_CLK_PERIOD/2;
    IF simulation_finished THEN
      WAIT;
    END IF;
  END PROCESS proc_clk_gen;

  --------------------------------------------------------------------------------
    ce_gen_i : ce_gen
  GENERIC MAP(
    G_DIV_FACT                  => 5
  )
  PORT MAP(
    CLK                         => clk,
    SRST                        => '0',
    CE                          => '1',
    CE_O                        => clk_en
  );
  --------------------------------------------------------------------------------

  -- Instanciace (zapojení) testované komponenty
  uart_tx_i : uart_tx
  PORT MAP(
    CLK       => clk,
    TX_START  => tx_start,
    CLK_EN    => clk_en,
    DATA_IN   => data_in,
    TX_BUSY   => tx_busy,
    UART_TXD  => uart_txd
  );

  --------------------------------------------------------------------------------

  proc_stim : PROCESS
  BEGIN
    tx_start <= '0';
    data_in  <= (others => '0');
    
    -- Počkáme po resetu/startu simulace
    WAIT FOR C_CLK_PERIOD * 5;
    

    data_in  <= x"A5";        
    tx_start <= '1';            -- Zapneme startovací signál
    
    WAIT FOR C_CLK_PERIOD * 5;  -- Počkáme dostatečně dlouho, aby to zachytil CLK_EN
    tx_start <= '0';            -- Vypneme startovací signál


    WAIT FOR C_CLK_PERIOD * 60; 


    WAIT FOR C_CLK_PERIOD * 5;
    simulation_finished <= TRUE;
    WAIT;
  END PROCESS proc_stim;

----------------------------------------------------------------------------------
end Behavioral;
----------------------------------------------------------------------------------