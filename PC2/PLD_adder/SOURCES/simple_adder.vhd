
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------
entity simple_adder is
    Port (
           A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Y : out STD_LOGIC_VECTOR (3 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC
           );
end simple_adder;
--------------------------------------------------------------
architecture Behavioral of simple_adder is

   SIGNAL a_uns: UNSIGNED (3 downto 0);
   SIGNAL b_uns: UNSIGNED (3 downto 0);
   SIGNAL y_uns: UNSIGNED (3 downto 0);
   SIGNAL c_uns: UNSIGNED (3 downto 0);
   SIGNAL sum:   UNSIGNED (4 downto 0);
   
begin
   
   a_uns <= UNSIGNED (A);
   b_uns <= UNSIGNED (B);
   
   y_uns <= a_uns + b_uns;
   
   Y <= STD_LOGIC_VECTOR(y_uns);
   
   sum <= ('0' & a_uns) + ('0' & b_uns);
   
   Y <= STD_LOGIC_VECTOR(sum(3 downto 0));

   C <= sum(4);
   

end Behavioral;
