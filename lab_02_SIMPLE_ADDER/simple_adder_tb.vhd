library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-------------------------------------------------------------------
entity simple_adder_tb is
end simple_adder_tb;
-------------------------------------------------------------------
architecture Behavioral of simple_adder_tb is
-------------------------------------------------------------------

    --component declaration
    COMPONENT simple_adder
    Port (
           A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Y : out STD_LOGIC_VECTOR (3 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC
          );
    end COMPONENT simple_adder;
    
   SIGNAL a_sig:STD_LOGIC_VECTOR (3 downto 0);
   SIGNAL b_sig:STD_LOGIC_VECTOR (3 downto 0);
   SIGNAL y_sig:STD_LOGIC_VECTOR (3 downto 0);
   SIGNAL y_ref:STD_LOGIC_VECTOR (3 downto 0);
   SIGNAL c_sig:STD_LOGIC;
   SIGNAL z_sig:STD_LOGIC;
   SIGNAL simulation_finished: BOOLEAN;


-------------------------------------------------------------------
begin
-------------------------------------------------------------------

    --COMPONENT INSTANTIATION
    --UUT-Unit under test
    
    simple_adder_i: simple_adder
    Port Map(
           A  => a_sig,
           B  => b_sig, 
           Y  => y_sig,
           C  => c_sig,
           Z  => z_sig
          );
          
 -------------------------------------------------------------------
 --STIMULUS GENERATOR
 stimuli_proc: PROCESS
 BEGIN
 
    LOOP_1: FOR i IN 15 DOWNTO 0 LOOP
        b_sig<= STD_LOGIC_VECTOR(TO_UNSIGNED(i,4));
        LOOP_2: FOR j IN 15 DOWNTO 0 LOOP
           a_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(j,4));
           WAIT FOR 10 ns;
        END LOOP LOOP_2;
    END LOOP LOOP_1; 
    
    --b_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(1,b_sig'length));

    --a_sig <= X"9";
    --b_sig <= X"9";
    
    simulation_finished <= TRUE;
    WAIT;
    
    --ASSERT y_sig = y_ref REPORT "SIMULATION FINISHED!" SEVERITY FAILURE;
 END PROCESS stimuli_proc;

--OUTPUT CHECKER
output_check: PROCESS
   VARIABLE cnt_err: INTEGER :=0;
BEGIN

   WAIT ON a_sig,b_sig,simulation_finished;
   
   y_ref <= STD_LOGIC_VECTOR (UNSIGNED(a_sig) + UNSIGNED(b_sig));
   WAIT FOR 1 ns;
   
   --? y_sig = y_ref
   
   --ASSERT y_sig = y_ref REPORT "ERROR IN ADDITION!" SEVERITY ERROR;
   
   IF NOT (y_sig = y_ref) THEN
      cnt_err:=cnt_err + 1;
      --REPORT "ERROR IN ADDITION! ERROR COUNT: " & integer'image(cnt_err)
      REPORT 
      "Error: expected Y=" & INTEGER'image(TO_INTEGER(UNSIGNED(y_ref)))&
      ",actual Y=" & INTEGER'image(TO_INTEGER(UNSIGNED(y_sig))) &
      " (INPUTS A=" & INTEGER'image(TO_INTEGER(UNSIGNED(a_sig))) &
      " ,B=" & INTEGER'image(TO_INTEGER(UNSIGNED(b_sig))) & " )"
      
      SEVERITY ERROR;
   END IF;
   
   IF simulation_finished THEN
     REPORT "FINISHED SIMULATION, ERROR COUNT: " & integer'image(cnt_err) SEVERITY ERROR;
     
   END IF;
   
END PROCESS output_check;
-------------------------------------------------------------------
end Behavioral;
-------------------------------------------------------------------