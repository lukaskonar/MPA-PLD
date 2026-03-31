library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY pwm_driver_tb IS
END pwm_driver_tb;

ARCHITECTURE Behavioral OF pwm_driver_tb IS


    CONSTANT C_CNT_WIDTH   : positive := 8;
    CONSTANT C_NUM_OUTPUTS : positive := 4; 
    CONSTANT C_CLK_PERIOD  : TIME := 20 ns;


    COMPONENT pwm_driver
        GENERIC (
            CNT_WIDTH   : positive;
            NUM_OUTPUTS : positive
        );
        PORT (
            clk     : IN  STD_LOGIC;
            ce      : IN  STD_LOGIC;
            duty_i  : IN  STD_LOGIC_VECTOR; 
            pwm_o   : OUT STD_LOGIC_VECTOR
        );
    END COMPONENT;

    SIGNAL clk      : STD_LOGIC := '0';
    SIGNAL ce       : STD_LOGIC := '1';
    SIGNAL duty_all : STD_LOGIC_VECTOR((C_NUM_OUTPUTS * C_CNT_WIDTH) - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pwm_out  : STD_LOGIC_VECTOR(C_NUM_OUTPUTS - 1 DOWNTO 0);

    SIGNAL F_sim_finished : BOOLEAN := FALSE;

BEGIN

    -- Instance driveru
    pwm_driver_i : pwm_driver
    GENERIC MAP (
        CNT_WIDTH   => C_CNT_WIDTH,
        NUM_OUTPUTS => C_NUM_OUTPUTS
    )
    PORT MAP(
        clk     => clk,
        ce      => ce,
        duty_i  => duty_all, 
        pwm_o   => pwm_out   
    );

    PROCESS
    BEGIN
        clk <= '0'; WAIT FOR C_CLK_PERIOD/2;
        clk <= '1'; WAIT FOR C_CLK_PERIOD/2;
        IF F_sim_finished THEN WAIT; END IF;
    END PROCESS;


    PROCESS
    BEGIN

        for i in 0 to C_NUM_OUTPUTS - 1 loop

            duty_all(((i+1)*C_CNT_WIDTH)-1 downto i*C_CNT_WIDTH) <= 
                std_logic_vector(to_unsigned(i * (256/C_NUM_OUTPUTS), C_CNT_WIDTH));
                
        end loop;

        WAIT FOR C_CLK_PERIOD * 1000;

        F_sim_finished <= TRUE;
        
        REPORT "Simulace hotova pro " & integer'image(C_NUM_OUTPUTS) & " vystupu!" 
        SEVERITY NOTE;
        
        WAIT;
    END PROCESS;

END ARCHITECTURE;