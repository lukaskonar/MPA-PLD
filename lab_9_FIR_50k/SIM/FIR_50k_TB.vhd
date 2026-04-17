----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE std.textio.ALL;
----------------------------------------------------------------------------------
entity FIR_50k_TB is
end FIR_50k_TB;
----------------------------------------------------------------------------------
architecture tb of FIR_50k_TB is
----------------------------------------------------------------------------------

  COMPONENT FIR_50k_wrapper IS
  GENERIC (
    SIM_MODEL                           : BOOLEAN := TRUE
  );
  PORT (
    aclk                                : IN  STD_LOGIC;
    s_axis_data_tvalid                  : IN  STD_LOGIC;
    s_axis_data_tready                  : OUT STD_LOGIC;
    s_axis_data_tdata                   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid                  : OUT STD_LOGIC;
    m_axis_data_tdata                   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
  END COMPONENT FIR_50k_wrapper;

  -----------------------------------------------------------------------

  SIGNAL sig_SIM_finished               : BOOLEAN := FALSE;     -- assert when all test vectors has been applied

  CONSTANT C_aclk_period                : time := 20 ns;
  SIGNAL aclk                           : STD_LOGIC := '0';

  SIGNAL s_axis_data_tvalid             : STD_LOGIC := '0';
  SIGNAL s_axis_data_tready             : STD_LOGIC;
  SIGNAL s_axis_data_tdata              : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
  SIGNAL m_axis_data_tvalid             : STD_LOGIC;
  SIGNAL m_axis_data_tdata              : STD_LOGIC_VECTOR(15 DOWNTO 0);

----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------


  --------------------------------------------------------------------------------
  -- Clock process definitions
  --------------------------------------------------------------------------------

  P_aclk: PROCESS
  BEGIN
    aclk <= '0'; WAIT FOR C_aclk_period/2;
    aclk <= '1'; WAIT FOR C_aclk_period/2;
    IF sig_SIM_finished THEN WAIT; END IF;
  END PROCESS P_aclk;


  -----------------------------------------------------------------------
  -- Instantiate the DUT
  -----------------------------------------------------------------------

  FIR_50k_wrapper_i : FIR_50k_wrapper
  GENERIC MAP(
    SIM_MODEL           => TRUE
  )
  PORT MAP(
    aclk                => aclk,
    s_axis_data_tvalid  => s_axis_data_tvalid,
    s_axis_data_tready  => s_axis_data_tready,
    s_axis_data_tdata   => s_axis_data_tdata,
    m_axis_data_tvalid  => m_axis_data_tvalid,
    m_axis_data_tdata   => m_axis_data_tdata
  );

  -----------------------------------------------------------------------
  -- FIR input
  --    read FIR_data_in.txt
  --    feed the FIR filter with the data from file
  -----------------------------------------------------------------------

read_txt: process 
    file File_ID      : text;
    variable line_in  : line;
    variable v_number : integer;
begin
    file_open(File_ID, "..\..\..\..\SOURCES\FIR_data\FIR_data_in.txt", read_mode);
    s_axis_data_tvalid <= '0';
    wait until falling_edge(aclk); 

    while not endfile(File_ID) loop
        readline(File_ID, line_in);
        read(line_in, v_number);

        while s_axis_data_tready = '0' loop
            wait until falling_edge(aclk);
        end loop;

        s_axis_data_tdata  <= std_logic_vector(to_signed(v_number, 16));
        s_axis_data_tvalid <= '1';
        wait for C_aclk_period;
        s_axis_data_tvalid <= '0';
        wait for C_aclk_period * 7; 
    end loop;
    file_close(File_ID);

    wait for C_aclk_period * 1000;
    sig_SIM_finished <= true;
    wait for C_aclk_period * 10;
    
    report "--- Verification Complete ---" severity note;
    assert false report "Simulace ukoncena" severity failure;
    wait;
end process read_txt;

  -----------------------------------------------------------------------
  -- FIR output data check
  --    read reference data from FIR_data_out.txt
  --    compare the reference and actual data
  --    report any discrepancy (both a text LOG file and simulator console)
  --    report overall test result
  -----------------------------------------------------------------------

write_txt_v3: process
    file file_exp       : text;
    file file_log       : text;
    variable line_exp   : line;
    variable line_log   : line;
    variable v_expected  : integer;
    variable v_actual    : integer;
    variable err_count   : integer := 0;
    variable msg_console : line; 
begin
    file_open(file_exp, "..\..\..\..\SOURCES\FIR_data\FIR_data_out.txt", read_mode);
    file_open(file_log, "..\..\..\..\SOURCES\FIR_data\FIR_sim_LOG.txt", write_mode);
    
    write(line_log, string'("--- FIR FILTER VERIFICATION LOG ---"));
    writeline(file_log, line_log);

    while not sig_SIM_finished loop
        wait until rising_edge(aclk);
        
        if m_axis_data_tvalid = '1' then
            if not endfile(file_exp) then
                readline(file_exp, line_exp);
                read(line_exp, v_expected);
            end if;

            v_actual := to_integer(signed(m_axis_data_tdata));

            if (v_expected /= v_actual) then
                err_count := err_count + 1;
                

                write(line_log, string'("Output error at " & time'image(now)));
                write(line_log, string'(". Expected data: "));
                write(line_log, v_expected);
                write(line_log, string'(" Actual data: "));
                write(line_log, v_actual);
                

                report "Error at " & time'image(now) & " | Exp: " & integer'image(v_expected) & " | Act: " & integer'image(v_actual) severity note;
                
                writeline(file_log, line_log);
            end if;
        end if;
    end loop;


    writeline(file_log, line_log); 
    write(line_log, string'("Total number of errors detected: "));
    write(line_log, err_count);
    writeline(file_log, line_log);
    
    if (err_count = 0) then
        write(line_log, string'("OVERALL TEST RESULT: PASS"));
    else
        write(line_log, string'("OVERALL TEST RESULT: FAIL"));
    end if;
    

    report "Verification finished. Total errors: " & integer'image(err_count) severity note;
    if (err_count = 0) then
        report "OVERALL TEST RESULT: PASS" severity note;
    else
        report "OVERALL TEST RESULT: FAIL" severity warning;
    end if;

    writeline(file_log, line_log);

    file_close(file_exp);
    file_close(file_log);
    wait;
end process write_txt_v3;
----------------------------------------------------------------------------------
end tb;
----------------------------------------------------------------------------------
