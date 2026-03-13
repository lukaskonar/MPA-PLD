----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY ce_gen IS
  GENERIC (
    G_DIV_FACT          : POSITIVE := 50000
  );
  PORT (
    CLK                 : IN  STD_LOGIC;
    SRST                : IN  STD_LOGIC;
    CE                  : IN  STD_LOGIC;
    CE_O                : OUT STD_LOGIC := '0'
  );
END ENTITY ce_gen;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen IS
----------------------------------------------------------------------------------
SIGNAL cnt_sig : INTEGER RANGE 0 TO G_DIV_FACT := 0;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
clk_en_gen: PROCESS(CLK) BEGIN
    IF rising_edge(CLK) THEN
    
        IF SRST = '1' THEN
                cnt_sig <= 0;
                
        ELSIF CE = '1' THEN       
            IF cnt_sig = G_DIV_FACT THEN
                cnt_sig <= 0;
                CE_O  <= '1';
            ELSE
                cnt_sig <= cnt_sig + 1;
                CE_O <= '0'; 
            END IF; 
        END IF;  
    END IF;
END PROCESS clk_en_gen;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
