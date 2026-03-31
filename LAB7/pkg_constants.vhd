library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package pkg_types is

    constant G_NCH : positive := 8;
    constant G_RES : positive := 8;

    -- Typ pro interní pole střídy
    type type_pwm_ref is array (G_NCH-1 downto 0) of std_logic_vector(G_RES-1 downto 0);
end package;