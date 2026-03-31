library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY rp_top IS
    PORT(
        CLK      : IN  STD_LOGIC;
        LED      : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END ENTITY rp_top;

ARCHITECTURE Behavioral OF rp_top IS


    COMPONENT pwm_driver
        PORT (
            CLK         : IN  STD_LOGIC;
            PWM_REF_7   : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            PWM_REF_6   : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            PWM_REF_5   : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            PWM_REF_4   : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            PWM_REF_3   : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            PWM_REF_2   : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            PWM_REF_1   : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            PWM_REF_0   : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
            PWM_OUT     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            CNT_OUT     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    END COMPONENT;

    signal s_cnt_open : std_logic_vector(7 downto 0);

BEGIN


    pwm_inst : pwm_driver
    PORT MAP(
        CLK        => CLK,
        
        PWM_REF_0  => x"00",  --   0 % 
        PWM_REF_1  => x"05",  --   2 % 
        PWM_REF_2  => x"10",  --   6 %
        PWM_REF_3  => x"20",  --  12 %
        PWM_REF_4  => x"40",  --  25 %
        PWM_REF_5  => x"80",  --  50 % 
        PWM_REF_6  => x"C0",  --  75 %
        PWM_REF_7  => x"FF",  -- 100 % 
        
        PWM_OUT    => LED,
        CNT_OUT    => s_cnt_open  
    );

END Behavioral;