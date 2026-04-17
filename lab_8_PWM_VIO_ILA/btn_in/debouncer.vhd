----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY debouncer IS
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );
  PORT(
    CLK                 : IN    STD_LOGIC;
    CE                  : IN    STD_LOGIC;
    BTN_IN              : IN    STD_LOGIC;
    BTN_OUT             : OUT   STD_LOGIC
  );
END ENTITY debouncer;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF debouncer IS
----------------------------------------------------------------------------------

  SIGNAL cnt_deb        : POSITIVE RANGE 1 TO G_DEB_PERIOD := 1;
  SIGNAL btn_in_del     : STD_LOGIC := '0';
  SIGNAL btn_deb        : STD_LOGIC := '0';

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------

  proc_debounce: PROCESS (CLK) BEGIN
    IF rising_edge(CLK) THEN

      btn_in_del <= BTN_IN;                     -- delay BTN_IN signal for edge detection

      IF btn_in_del /= BTN_IN THEN              -- BTN_IN signal change?
        IF cnt_deb = G_DEB_PERIOD THEN          -- blanking is over?
          btn_deb <= BTN_IN;                    -- if so, update BTN_OUT value
        END IF;
        cnt_deb <= 1;                           -- reset counter at each BTN_IN signal change (edge)
      ELSIF CE = '1' THEN
        IF cnt_deb /= G_DEB_PERIOD THEN
          cnt_deb <= cnt_deb + 1;                 -- increment counter up to G_DEB_PERIOD whenever CE = '1'
        END IF;
      END IF;

    END IF;
  END PROCESS proc_debounce;


  BTN_OUT <= btn_deb;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
