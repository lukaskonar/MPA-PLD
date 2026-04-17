----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE WORK.pkg_constants.ALL;
USE WORK.pkg_types.ALL;
----------------------------------------------------------------------------------
ENTITY pwm_driver_par_tb IS
END pwm_driver_par_tb;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF pwm_driver_par_tb IS
----------------------------------------------------------------------------------

  COMPONENT pwm_driver_par
  PORT(
    CLK       : IN  STD_LOGIC;
    PWM_REF   : IN  type_pwm_ref;

    PWM_OUT   : OUT STD_LOGIC_VECTOR(G_NCH-1 DOWNTO 0);
    CNT_OUT   : OUT STD_LOGIC_VECTOR(G_RES-1 DOWNTO 0)
  );
  END COMPONENT;

  --------------------------------------------------------------------------------

  SIGNAL clk            : STD_LOGIC := '0';

  SIGNAL pwm_ref        : type_pwm_ref := (OTHERS => (OTHERS => '0'));

  SIGNAL pwm_out        : STD_LOGIC_VECTOR (G_NCH-1 DOWNTO 0);
  SIGNAL cnt_out        : STD_LOGIC_VECTOR (G_RES-1 DOWNTO 0);

  --------------------------------------------------------------------------------

  CONSTANT C_CLK_PERIOD     : TIME := 20 ns;
  SIGNAL F_sim_finished     : BOOLEAN := FALSE;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  pwm_driver_par_i : pwm_driver_par
  PORT MAP(
    CLK                 => clk,
    PWM_REF             => pwm_ref,
    PWM_OUT             => pwm_out,
    CNT_OUT             => cnt_out
  );

  --------------------------------------------------------------------------------

  PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR C_CLK_PERIOD/2;
    clk <= '1';
    WAIT FOR C_CLK_PERIOD/2;
    IF F_sim_finished THEN
      WAIT;
    END IF;
  END PROCESS;

  --------------------------------------------------------------------------------

  PROCESS
    VARIABLE v_pwm_ref  : STD_LOGIC_VECTOR(G_RES-1 DOWNTO 0) := (OTHERS => '0');
  BEGIN
    ------------------------------------------------------------------------------
    -- initialize PWM references
    FOR i IN 0 TO G_NCH-1 LOOP
      pwm_ref(i) <= v_pwm_ref;
      v_pwm_ref := v_pwm_ref(v_pwm_ref'HIGH-1 DOWNTO 0) & '1';
    END LOOP;

    WAIT FOR C_CLK_PERIOD*2000;

    ------------------------------------------------------------------------------

    F_sim_finished <= TRUE;

    ------------------------------------------------------------------------------
    -- final report
    REPORT LF &
             "================================================================" & LF &
             "Simulation finished! Check the waveform window!" & LF &
             "================================================================" & LF
             SEVERITY NOTE;

    WAIT;
  END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE;
----------------------------------------------------------------------------------
