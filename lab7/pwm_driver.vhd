library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY pwm_driver IS
    GENERIC (
        CNT_WIDTH   : positive := 8;  -- Šířka čítače a střídy
        NUM_OUTPUTS : positive := 8   -- Počet výstupů a komparátorů
    );
    PORT (
        clk     : IN  STD_LOGIC;
        ce      : IN  STD_LOGIC;

        duty_i  : IN  STD_LOGIC_VECTOR((NUM_OUTPUTS * CNT_WIDTH) - 1 DOWNTO 0);
        pwm_o   : OUT STD_LOGIC_VECTOR(NUM_OUTPUTS - 1 DOWNTO 0)
    );
END pwm_driver;

ARCHITECTURE Behavioral OF pwm_driver IS
    signal cnt_reg : unsigned(CNT_WIDTH - 1 downto 0) := (others => '0');
BEGIN


    process(clk)
    begin
        if rising_edge(clk) then
            if ce = '1' then
                cnt_reg <= cnt_reg + 1;
            end if;
        end if;
    end process;


    gen_pwm: for i in 0 to NUM_OUTPUTS - 1 generate
        pwm_o(i) <= '1' when cnt_reg < unsigned(duty_i(((i + 1) * CNT_WIDTH) - 1 downto i * CNT_WIDTH)) else '0';
    end generate;

END Behavioral;