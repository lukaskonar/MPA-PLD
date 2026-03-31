library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.pkg_types.all;

ENTITY pwm_driver IS
    PORT (
        CLK        : IN  STD_LOGIC;

        PWM_REF_7  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        PWM_REF_6  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        PWM_REF_5  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        PWM_REF_4  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        PWM_REF_3  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        PWM_REF_2  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        PWM_REF_1  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
        PWM_REF_0  : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);

        PWM_OUT    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        CNT_OUT    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END pwm_driver;

ARCHITECTURE Behavioral OF pwm_driver IS

    signal cnt_pwm : unsigned(G_RES-1 downto 0) := (others => '0');
    
    -- Interní pole pro snadnější obsluhu komparátorů v cyklu
    signal pwm_ref_array : type_pwm_ref;
BEGIN


    pwm_ref_array(0) <= PWM_REF_0;
    pwm_ref_array(1) <= PWM_REF_1;
    pwm_ref_array(2) <= PWM_REF_2;
    pwm_ref_array(3) <= PWM_REF_3;
    pwm_ref_array(4) <= PWM_REF_4;
    pwm_ref_array(5) <= PWM_REF_5;
    pwm_ref_array(6) <= PWM_REF_6;
    pwm_ref_array(7) <= PWM_REF_7;

    process(CLK)
    begin
        if rising_edge(CLK) then
            cnt_pwm <= cnt_pwm + 1;
        end if;
    end process;


    CNT_OUT <= std_logic_vector(cnt_pwm);

    -- 4. PWM Komparátory (Bonusový úkol: implementace pomocí generate)
    -- Vytvoří G_NCH komparátorů automaticky
    gen_comparators: for i in 0 to G_NCH-1 generate
        PWM_OUT(i) <= '1' when cnt_pwm < unsigned(pwm_ref_array(i)) else '0';
    end generate;

END Behavioral;