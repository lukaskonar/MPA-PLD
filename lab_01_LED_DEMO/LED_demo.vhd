library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
------------------------------------------

entity LED_demo is
    Port ( 
        SW : in STD_LOGIC_VECTOR (1 to 4);
        BTN : in STD_LOGIC_VECTOR (1 to 4);
        LED : out STD_LOGIC_VECTOR (7 downto 0)
        );
end LED_demo;
------------------------------------------

architecture Behavioral of LED_demo is

begin

    LED(1) <= BTN(1);
    
    LED(0) <= '1'WHEN SW = "1001" AND BTN = "0101" ELSE
              '0';
    
    LED(7 DOWNTO 4 ) <= "1111";
    

end Behavioral;
