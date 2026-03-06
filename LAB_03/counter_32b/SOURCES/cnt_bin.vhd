----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2026 09:37:19 AM
-- Design Name: 
-- Module Name: cnt_bin - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cnt_bin is
    PORT ( 
    CLK     :IN  STD_LOGIC;  
    CNT_UP  :IN STD_LOGIC;
    CNT_LOAD:IN STD_LOGIC;
    CE      :IN STD_LOGIC;
    SRST    :IN STD_LOGIC;
    CNT     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
    
end cnt_bin;

architecture Behavioral of cnt_bin is
    SIGNAL cnt_sig   : UNSIGNED (31 DOWNTO 0) := (OTHERS => '0');

begin

PROCESS (CLK)
BEGIN
    IF rising_edge(CLK) THEN
    
        IF SRST = '1' THEN
            cnt_sig <= (OTHERS => '0');
            
        ELSIF CE = '1' THEN
        
            IF CNT_LOAD = '1' THEN
                cnt_sig <= x"55555555";
                
            ELSE
                IF CNT_UP = '1' THEN
                    cnt_sig <= cnt_sig + 1;
                ELSE
                    cnt_sig <= cnt_sig - 1;
                END IF;
                
            END IF;
            
        END IF;
        
    END IF;
END PROCESS;
CNT <= STD_LOGIC_VECTOR(cnt_sig);

end Behavioral;
