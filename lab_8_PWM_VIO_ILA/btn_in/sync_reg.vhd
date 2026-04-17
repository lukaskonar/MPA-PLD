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

  SIGNAL sync_sh_reg        : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

  ATTRIBUTE ASYNC_REG                       : STRING;
  ATTRIBUTE ASYNC_REG OF sync_sh_reg        : SIGNAL IS "TRUE";

  ATTRIBUTE SHREG_EXTRACT                   : STRING;
  ATTRIBUTE SHREG_EXTRACT OF sync_sh_reg    : SIGNAL IS "NO";

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  proc_sync_reg: PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
      sync_sh_reg <= sync_sh_reg(sync_sh_reg'HIGH-1 DOWNTO 0) & SIG_IN;
    END IF;
  END PROCESS proc_sync_reg;

  SIG_OUT <= sync_sh_reg(sync_sh_reg'HIGH);

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
