
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------
ENTITY uart_tx IS 
    PORT( CLK       : IN STD_LOGIC; 
          TX_START  : IN STD_LOGIC; 
          CLK_EN    : IN STD_LOGIC;  
          DATA_IN   : IN STD_LOGIC_VECTOR(7 downto 0);     
          TX_BUSY   : OUT STD_LOGIC;     
          UART_TXD  : OUT STD_LOGIC   
);
END uart_tx;
--------------------------------------------------------------
architecture Behavioral of uart_tx is

TYPE t_st_uart IS (st_idle, st_start_b, st_bit_0, st_bit_1, st_bit_2, st_bit_3, st_bit_4, st_bit_5, st_bit_6, st_bit_7, st_stop_b); 
SIGNAL pres_st           : t_st_uart := st_idle;
SIGNAL next_st             : t_st_uart;

SIGNAL uart_txd_c: STD_LOGIC;
SIGNAL uart_txd_reg : STD_LOGIC := '1';
SIGNAL busy_c: STD_LOGIC;
SIGNAL TX_BUSY_REG: STD_LOGIC;
SIGNAL start_flag : STD_LOGIC := '0';

SIGNAL data_reg: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
----------------------------------------------------    
begin
----------------------------------------------------
PROCESS (pres_st, TX_START) BEGIN 

    CASE pres_st IS 
    WHEN st_idle       => IF start_flag = '1' THEN
                              next_st <= st_start_b;
                          ELSE 
                              next_st <= st_idle; 
                          END IF;
                            
    WHEN st_start_b      => next_st <= st_bit_0;
    WHEN st_bit_0        => next_st <= st_bit_1;
    WHEN st_bit_1        => next_st <= st_bit_2;
    WHEN st_bit_2        => next_st <= st_bit_3;
    WHEN st_bit_3        => next_st <= st_bit_4;
    WHEN st_bit_4        => next_st <= st_bit_5;
    WHEN st_bit_5        => next_st <= st_bit_6;
    WHEN st_bit_6        => next_st <= st_bit_7; 
    WHEN st_bit_7        => next_st <= st_stop_b;
    WHEN st_stop_b       => next_st <= st_idle;
    
    END CASE;
END PROCESS;
-----------------------------------------------------------
PROCESS (pres_st, data_reg) BEGIN  
    busy_c <= '1';
    CASE pres_st IS  
        WHEN st_Idle     => uart_txd_c <= '1'; busy_c <= '0';
        WHEN st_start_b  => uart_txd_c <= '0';  
        WHEN st_bit_0    => uart_txd_c <= data_reg(0);
        WHEN st_bit_1    => uart_txd_c <= data_reg(1);  
        WHEN st_bit_2    => uart_txd_c <= data_reg(2);  
        WHEN st_bit_3    => uart_txd_c <= data_reg(3);  
        WHEN st_bit_4    => uart_txd_c <= data_reg(4);  
        WHEN st_bit_5    => uart_txd_c <= data_reg(5);  
        WHEN st_bit_6    => uart_txd_c <= data_reg(6);
        WHEN st_bit_7    => uart_txd_c <= data_reg(7);
        WHEN st_stop_b   => uart_txd_c <= '1';              
                                               
    END CASE; 
 END PROCESS;
 ----------------------------------------------------------
PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN 

        IF pres_st = st_idle AND TX_START = '1' THEN
            data_reg <= DATA_IN;
            start_flag <= '1';
        END IF;

        IF CLK_EN = '1' THEN
            pres_st <= next_st;    
            uart_txd_reg <= uart_txd_c; 
            TX_BUSY_REG <= busy_c;
            
            IF pres_st /= st_idle THEN
                start_flag <= '0';
            END IF;
        END IF;   
    END IF;
END PROCESS;

UART_TXD <= uart_txd_reg;
TX_BUSY  <= TX_BUSY_REG;

-----------------------------------------------------
end Behavioral;
