----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY edge_detector IS
  PORT(
    CLK                 : IN    STD_LOGIC;
    SIG_IN              : IN    STD_LOGIC;
    EDGE_POS            : OUT   STD_LOGIC;
    EDGE_NEG            : OUT   STD_LOGIC;
    EDGE_ANY            : OUT   STD_LOGIC
  );
END ENTITY edge_detector;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF edge_detector IS
----------------------------------------------------------------------------------

  SIGNAL sig_in_del         : STD_LOGIC := '0';

  SIGNAL edge_pos_i         : STD_LOGIC := '0';
  SIGNAL edge_neg_i         : STD_LOGIC := '0';
  SIGNAL edge_any_i         : STD_LOGIC := '0';

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  proc_edge_detect: PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      sig_in_del <= SIG_IN;

      -- default assignment
      edge_pos_i <= '0';
      edge_neg_i <= '0';
      edge_any_i <= '0';

      -- rising edge detection
      IF SIG_IN = '1' AND sig_in_del = '0' THEN
        edge_pos_i <= '1';
        edge_any_i <= '1';
      END IF;

      -- falling edge detection
      IF SIG_IN = '0' AND sig_in_del = '1' THEN
        edge_neg_i <= '1';
        edge_any_i <= '1';
      END IF;

    END IF;
  END PROCESS proc_edge_detect;


  EDGE_POS <= edge_pos_i;
  EDGE_NEG <= edge_neg_i;
  EDGE_ANY <= edge_any_i;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
