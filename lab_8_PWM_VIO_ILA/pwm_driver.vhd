----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
----------------------------------------------------------------------------------
ENTITY pwm_driver IS
  PORT (
    CLK                 : IN  STD_LOGIC;
    PWM_REF_7           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_6           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_5           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_4           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_3           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_2           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_1           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_0           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    CNT_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END pwm_driver;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF pwm_driver IS
----------------------------------------------------------------------------------

  SIGNAL cnt_pwm        : UNSIGNED ( 7 DOWNTO 0) := (OTHERS => '0');

  SIGNAL pwm_out_comb   : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
  SIGNAL pwm_out_reg    : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- PWM counter
  --------------------------------------------------------------------------------

  PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN
      IF cnt_pwm = 254 THEN
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

  PROCESS (PWM_REF_0, PWM_REF_1, PWM_REF_2, PWM_REF_3, PWM_REF_4, PWM_REF_5, PWM_REF_6, PWM_REF_7, cnt_pwm) BEGIN
    IF UNSIGNED(PWM_REF_0) > cnt_pwm THEN pwm_out_comb(0) <= '1'; ELSE pwm_out_comb(0) <= '0'; END IF;
    IF UNSIGNED(PWM_REF_1) > cnt_pwm THEN pwm_out_comb(1) <= '1'; ELSE pwm_out_comb(1) <= '0'; END IF;
    IF UNSIGNED(PWM_REF_2) > cnt_pwm THEN pwm_out_comb(2) <= '1'; ELSE pwm_out_comb(2) <= '0'; END IF;
    IF UNSIGNED(PWM_REF_3) > cnt_pwm THEN pwm_out_comb(3) <= '1'; ELSE pwm_out_comb(3) <= '0'; END IF;
    IF UNSIGNED(PWM_REF_4) > cnt_pwm THEN pwm_out_comb(4) <= '1'; ELSE pwm_out_comb(4) <= '0'; END IF;
    IF UNSIGNED(PWM_REF_5) > cnt_pwm THEN pwm_out_comb(5) <= '1'; ELSE pwm_out_comb(5) <= '0'; END IF;
    IF UNSIGNED(PWM_REF_6) > cnt_pwm THEN pwm_out_comb(6) <= '1'; ELSE pwm_out_comb(6) <= '0'; END IF;
    IF UNSIGNED(PWM_REF_7) > cnt_pwm THEN pwm_out_comb(7) <= '1'; ELSE pwm_out_comb(7) <= '0'; END IF;
  END PROCESS;

  PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN
      pwm_out_reg <= pwm_out_comb;
    END IF;
  END PROCESS;


  --------------------------------------------------------------------------------
  -- PWM comparators and output registers
  --        sequential part of the design merged into single PROCESS statement
  --------------------------------------------------------------------------------

--PROCESS (CLK) BEGIN
--  IF rising_edge(CLK) THEN
--    IF UNSIGNED(PWM_REF_0) > cnt_pwm THEN pwm_out_reg(0) <= '1'; ELSE pwm_out_reg(0) <= '0'; END IF;
--    IF UNSIGNED(PWM_REF_1) > cnt_pwm THEN pwm_out_reg(1) <= '1'; ELSE pwm_out_reg(1) <= '0'; END IF;
--    IF UNSIGNED(PWM_REF_2) > cnt_pwm THEN pwm_out_reg(2) <= '1'; ELSE pwm_out_reg(2) <= '0'; END IF;
--    IF UNSIGNED(PWM_REF_3) > cnt_pwm THEN pwm_out_reg(3) <= '1'; ELSE pwm_out_reg(3) <= '0'; END IF;
--    IF UNSIGNED(PWM_REF_4) > cnt_pwm THEN pwm_out_reg(4) <= '1'; ELSE pwm_out_reg(4) <= '0'; END IF;
--    IF UNSIGNED(PWM_REF_5) > cnt_pwm THEN pwm_out_reg(5) <= '1'; ELSE pwm_out_reg(5) <= '0'; END IF;
--    IF UNSIGNED(PWM_REF_6) > cnt_pwm THEN pwm_out_reg(6) <= '1'; ELSE pwm_out_reg(6) <= '0'; END IF;
--    IF UNSIGNED(PWM_REF_7) > cnt_pwm THEN pwm_out_reg(7) <= '1'; ELSE pwm_out_reg(7) <= '0'; END IF;
--  END IF;
--END PROCESS;


  --------------------------------------------------------------------------------
  -- connect internal signals to output ports
  --------------------------------------------------------------------------------

  PWM_OUT <= pwm_out_reg;
  CNT_OUT <= STD_LOGIC_VECTOR(cnt_pwm);


----------------------------------------------------------------------------------
END Behavioral;
----------------------------------------------------------------------------------
