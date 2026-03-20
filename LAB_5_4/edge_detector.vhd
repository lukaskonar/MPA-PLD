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
SIGNAL SIG_IN_DEL : STD_LOGIC :='0' ;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
PROCESS (CLK) BEGIN
    IF rising_edge(clk) THEN

        SIG_IN_DEL <= SIG_IN;
        EDGE_POS <= SIG_IN and (not SIG_IN_DEL);
        EDGE_NEG <= (not SIG_IN) and SIG_IN_DEL;
        EDGE_ANY <= SIG_IN xor SIG_IN_DEL;
        
    END IF;
END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
