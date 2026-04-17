----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.pkg_FIR_50k_SIM.ALL;     -- contains C_FIR_IN and C_FIR_RESPONSE
----------------------------------------------------------------------------------
ENTITY FIR_50k_SIM IS
  PORT (
    aclk                                : IN  STD_LOGIC;
    s_axis_data_tvalid                  : IN  STD_LOGIC;
    s_axis_data_tready                  : OUT STD_LOGIC;
    s_axis_data_tdata                   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid                  : OUT STD_LOGIC := '0';
    m_axis_data_tdata                   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
  );
END FIR_50k_SIM;
----------------------------------------------------------------------------------
ARCHITECTURE structural OF FIR_50k_SIM IS
----------------------------------------------------------------------------------

  SIGNAL cnt_fir_out                    : INTEGER := 0;
  SIGNAL cnt_fir_in                     : INTEGER := 0;

  SIGNAL s_axis_data_tready_i           : STD_LOGIC := '0';

  CONSTANT C_FIR_LATENCY                : INTEGER := 19;
  SIGNAL dv_sh_reg                      : STD_LOGIC_VECTOR(C_FIR_LATENCY-1 DOWNTO 0) := (OTHERS => '0');

  SIGNAL cnt_tready                     : INTEGER RANGE 0 TO 7 := 0;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  PROCESS(aclk) BEGIN
    IF rising_edge(aclk) THEN
      IF s_axis_data_tvalid = '1' AND s_axis_data_tready_i = '1' THEN
        IF NOT (STD_LOGIC_VECTOR(TO_SIGNED(C_FIR_IN(cnt_fir_in),s_axis_data_tdata'LENGTH)) = s_axis_data_tdata) THEN
          REPORT LF & "----------------------------------------------------------------------------------" & LF &
                 "ERROR: Mismatch of input data! Expected data " &
                 INTEGER'image(C_FIR_IN(cnt_fir_in)) &
                 ", actual data " &
                 INTEGER'image(TO_INTEGER(SIGNED(s_axis_data_tdata))) &
                 LF & "----------------------------------------------------------------------------------" & LF
          SEVERITY ERROR;
        END IF;
        cnt_fir_in <= cnt_fir_in + 1;
      END IF;
    END IF;
  END PROCESS;


  --------------------------------------------------------------------------------

  PROCESS(aclk) BEGIN
    IF rising_edge(aclk) THEN

      IF cnt_tready = 6 THEN
        s_axis_data_tready_i <= '1';
        IF s_axis_data_tvalid = '1' AND s_axis_data_tready_i = '1' THEN
          cnt_tready <= 0;
          s_axis_data_tready_i <= '0';
        END IF;
      ELSE
        cnt_tready <= cnt_tready + 1;
        s_axis_data_tready_i <= '0';
      END IF;

      IF s_axis_data_tvalid = '1' AND s_axis_data_tready_i = '1' THEN
        dv_sh_reg <= dv_sh_reg(dv_sh_reg'HIGH-1 DOWNTO 0) & '1';
      ELSE
        dv_sh_reg <= dv_sh_reg(dv_sh_reg'HIGH-1 DOWNTO 0) & '0';
      END IF;
    

      IF dv_sh_reg(dv_sh_reg'HIGH) = '1' THEN

        IF cnt_fir_out = 999 THEN
          cnt_fir_out <= 0;
        ELSE
          cnt_fir_out <= cnt_fir_out + 1;
        END IF;

        m_axis_data_tdata <= STD_LOGIC_VECTOR(TO_SIGNED(C_FIR_RESPONSE(cnt_fir_out),m_axis_data_tdata'LENGTH));

      END IF;

      m_axis_data_tvalid <= dv_sh_reg(dv_sh_reg'HIGH);

    END IF;
  END PROCESS;


  s_axis_data_tready <= s_axis_data_tready_i;

----------------------------------------------------------------------------------
END structural;
----------------------------------------------------------------------------------
