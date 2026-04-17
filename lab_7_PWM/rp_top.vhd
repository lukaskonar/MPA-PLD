library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY rp_top IS
    PORT(
        CLK : IN  STD_LOGIC;
        LED : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END ENTITY rp_top;

ARCHITECTURE Behavioral OF rp_top IS

    signal s_duty_array : STD_LOGIC_VECTOR((8 * 8) - 1 downto 0);

BEGIN


    s_duty_array <= x"FF" & x"7F" & x"3F" & x"1F" & x"07" & x"03" & x"01" & x"00";


    pwm_inst : entity work.pwm_driver
    GENERIC MAP (
        CNT_WIDTH   => 8,
        NUM_OUTPUTS => 8
    )
    PORT MAP (
        clk     => CLK,
        ce      => '1',            
        duty_i  => s_duty_array,
        pwm_o   => LED
    );

END Behavioral;