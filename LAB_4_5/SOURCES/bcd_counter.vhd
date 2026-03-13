----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY bcd_counter IS
  PORT(
    CLK                 : IN    STD_LOGIC;      -- clock signal
    CE_100HZ            : IN    STD_LOGIC;      -- 100 Hz clock enable
    CNT_RESET           : IN    STD_LOGIC;      -- counter reset
    CNT_ENABLE          : IN    STD_LOGIC;      -- counter enable
    DISP_ENABLE         : IN    STD_LOGIC;      -- enable display update
    CNT_0               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_1               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_2               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_3               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END ENTITY bcd_counter;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF bcd_counter IS
----------------------------------------------------------------------------------
SIGNAL cnt_0_reg : UNSIGNED (3 DOWNTO 0) := (OTHERS => '0');
SIGNAL cnt_1_reg : UNSIGNED (3 DOWNTO 0) := (OTHERS => '0');
SIGNAL cnt_2_reg : UNSIGNED (3 DOWNTO 0) := (OTHERS => '0');
SIGNAL cnt_3_reg : UNSIGNED (3 DOWNTO 0) := (OTHERS => '0');

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
  -- BCD counter
BCD_counter: PROCESS (CLK) BEGIN 
IF rising_edge(CLK) THEN
    IF CE_100HZ = '1' and  CNT_ENABLE = '1' THEN

        IF (cnt_3_reg = X"5" and cnt_2_reg = X"9" and cnt_1_reg = X"9" and cnt_0_reg = X"9") or (CNT_RESET = '1') THEN
            cnt_0_reg <= (others => '0');
            cnt_1_reg <= (others => '0');
            cnt_2_reg <= (others => '0');
            cnt_3_reg <= (others => '0');

        ELSIF cnt_0_reg = X"9" THEN
            cnt_0_reg <= (others => '0');

            IF cnt_1_reg = X"9" THEN
                cnt_1_reg <= (others => '0');

                IF cnt_2_reg = X"9" THEN
                    cnt_2_reg <= (others => '0');
                    cnt_3_reg <= cnt_3_reg + 1;
                ELSE
                    cnt_2_reg <= cnt_2_reg + 1;
                END IF;

            ELSE
                cnt_1_reg <= cnt_1_reg + 1;
            END IF;

        ELSE
            cnt_0_reg <= cnt_0_reg + 1;
        END IF;

    END IF;
END IF; 
END PROCESS BCD_counter;

  --------------------------------------------------------------------------------
  -- Output (display) register
display: PROCESS (CLK) BEGIN 
    IF rising_edge(clk) THEN
        IF DISP_ENABLE = '1' THEN 
            CNT_0 <= STD_LOGIC_VECTOR (cnt_0_reg);
            CNT_1 <= STD_LOGIC_VECTOR (cnt_1_reg);
            CNT_2 <= STD_LOGIC_VECTOR (cnt_2_reg);
            CNT_3 <= STD_LOGIC_VECTOR (cnt_3_reg);
        END IF;
    END IF;
END PROCESS display;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
