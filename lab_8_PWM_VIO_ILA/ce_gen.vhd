----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY ce_gen IS
  GENERIC (
    G_DIV_FACT          : POSITIVE := 2
  );
  PORT (
    CLK                 : IN  STD_LOGIC;
    SRST                : IN  STD_LOGIC;
    CE                  : IN  STD_LOGIC;
    CE_O                : OUT STD_LOGIC
  );
END ENTITY ce_gen;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen IS
----------------------------------------------------------------------------------

  SIGNAL cnt        : POSITIVE RANGE 1 TO G_DIV_FACT := 1;
  SIGNAL ce_sig     : STD_LOGIC := '0';

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  proc_ce_gen: PROCESS(CLK) BEGIN
    IF rising_edge(CLK) THEN
      IF SRST = '1' THEN
        cnt <= 1;
        ce_sig <= '0';
      ELSIF CE = '1' THEN
        cnt <= cnt + 1;
        ce_sig <= '0';
        IF cnt = G_DIV_FACT THEN
          cnt <= 1;
          ce_sig <= '1';
        END IF;
      END IF;
    END IF;
  END PROCESS proc_ce_gen;

  CE_O <= ce_sig;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
