----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
USE WORK.pkg_constants.ALL;
USE WORK.pkg_types.ALL;
----------------------------------------------------------------------------------
--
-- Note that G_NCH and G_RES are defined in pkg_constants!
--
ENTITY pwm_driver_par IS
  PORT(
    CLK       : IN  STD_LOGIC;
    PWM_REF   : IN  type_pwm_ref;

    PWM_OUT   : OUT STD_LOGIC_VECTOR(G_NCH-1 DOWNTO 0);
    CNT_OUT   : OUT STD_LOGIC_VECTOR(G_RES-1 DOWNTO 0)
  );
END pwm_driver_par;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF pwm_driver_par IS
----------------------------------------------------------------------------------


  SIGNAL cnt_pwm        : UNSIGNED (G_RES-1 DOWNTO 0) := (OTHERS => '0');

  SIGNAL pwm_out_comb   : STD_LOGIC_VECTOR (G_NCH-1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_out_reg    : STD_LOGIC_VECTOR (G_NCH-1 DOWNTO 0) := (OTHERS => '0');

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- PWM counter
  --------------------------------------------------------------------------------

  PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN
      IF cnt_pwm = ((2**G_RES)-2) THEN
        cnt_pwm <= (OTHERS => '0');
      ELSE
        cnt_pwm <= cnt_pwm + 1;
      END IF;
    END IF;
  END PROCESS;


  --------------------------------------------------------------------------------
  -- PWM comparators and output registers
  --        separated combinatorial and sequential part of the design
  --------------------------------------------------------------------------------

--  -- PWM comparator
--  PROCESS (PWM_REF, cnt_pwm) BEGIN
--    pwm_out_comb <= (OTHERS => '0');            -- default assignment
--    FOR i IN 0 TO G_NCH-1 LOOP
--      IF UNSIGNED(PWM_REF(i)) > cnt_pwm THEN
--        pwm_out_comb(i) <= '1';
--      END IF;
--    END LOOP;
--  END PROCESS;
--
--  -- Output register
--  PROCESS (CLK) BEGIN
--    IF rising_edge(CLK) THEN
--      pwm_out_reg <= pwm_out_comb;
--    END IF;
--  END PROCESS;


  --------------------------------------------------------------------------------
  -- PWM comparators and output registers
  --        sequential part of the design merged into single PROCESS statement
  --------------------------------------------------------------------------------

  PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN
      pwm_out_reg <= (OTHERS => '0');           -- default assignment
      FOR i IN 0 TO G_NCH-1 LOOP
        IF UNSIGNED(PWM_REF(i)) > cnt_pwm THEN
          pwm_out_reg(i) <= '1';
        END IF;
      END LOOP;
    END IF;
  END PROCESS;


  --------------------------------------------------------------------------------
  -- connect internal signals to output ports
  --------------------------------------------------------------------------------

  PWM_OUT <= pwm_out_reg;
  CNT_OUT <= STD_LOGIC_VECTOR(cnt_pwm);


----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
