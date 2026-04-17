----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY sync_reg IS
  PORT(
    CLK                 : IN    STD_LOGIC;
    SIG_IN              : IN    STD_LOGIC;
    SIG_OUT             : OUT   STD_LOGIC
  );
END ENTITY sync_reg;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF sync_reg IS
----------------------------------------------------------------------------------
SIGNAL SIG_REG : STD_LOGIC;

attribute SHREG_EXTRACT               : string; 
attribute SHREG_EXTRACT of SIG_REG    : signal is "TRUE";
attribute SHREG_EXTRACT of SIG_OUT    : signal is "TRUE"; 
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

PROCESS (CLK) BEGIN 
    IF rising_edge(CLK) THEN
        SIG_REG <= SIG_IN;   
        SIG_OUT <= SIG_REG;  
    END IF;
END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
