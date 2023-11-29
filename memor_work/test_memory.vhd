--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   05:06:32 11/29/2023
-- Design Name:   
-- Module Name:   C:/Documents and Settings/lester/Escritorio/OOOOOOO/memor_work/test_memory.vhd
-- Project Name:  memor_work
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mem_work
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_memory IS
END test_memory;
 
ARCHITECTURE behavior OF test_memory IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mem_work
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         en_boot : IN  std_logic;
         port_data_in : IN  std_logic_vector(7 downto 0);
         port_en_data_in : IN  std_logic;
         port_en_data_out : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '1';
   signal en_boot : std_logic := '0';
   signal port_data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal port_en_data_in : std_logic := '0';
   signal port_en_data_out : std_logic := '0';

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mem_work PORT MAP (
          clock => clock,
          reset => reset,
          en_boot => en_boot,
          port_data_in => port_data_in,
          port_en_data_in => port_en_data_in,
          port_en_data_out => port_en_data_out
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		reset <= '0';

		wait for 30 ns;
		en_boot <= '1';
		
		
		
		--send command
		wait for 68 ns;
		port_data_in <= x"01";
		
		wait for 30 ns;
		port_en_data_in <= '1';
		wait for 30 ns;
		port_en_data_in <= '0';
		
		--send size
		wait for 44 ns;
		port_data_in <= x"04";
		
		wait for 30 ns;
		port_en_data_in <= '1';
		wait for 30 ns;
		port_en_data_in <= '0';
		
		--send addr_h
		wait for 35 ns;
		port_data_in <= x"00";
		
		wait for 30 ns;
		port_en_data_in <= '1';
		wait for 30 ns;
		port_en_data_in <= '0';
		
		--send addr_l
		wait for 35 ns;
		port_data_in <= x"FF";
		
		wait for 30 ns;
		port_en_data_in <= '1';
		wait for 30 ns;
		port_en_data_in <= '0';
		
		--send code
		wait for 35 ns;
		port_data_in <= x"00";
		
		wait for 30 ns;
		port_en_data_in <= '1';
		wait for 30 ns;
		port_en_data_in <= '0';
		
		--send data
		wait for 35 ns;
		port_data_in <= x"04";
		
		wait for 30 ns;
		port_en_data_in <= '1';
		wait for 30 ns;
		port_en_data_in <= '0';
		
		wait for 35 ns;
		port_data_in <= x"05";
		
		wait for 30 ns;
		port_en_data_in <= '1';
		wait for 30 ns;
		port_en_data_in <= '0';
		
		wait for 35 ns;
		port_data_in <= x"06";
		
		wait for 30 ns;
		port_en_data_in <= '1';
		wait for 30 ns;
		port_en_data_in <= '0';
		
		wait for 35 ns;
		port_data_in <= x"07";
		
		wait for 30 ns;
		port_en_data_in <= '1';
		wait for 30 ns;
		port_en_data_in <= '0';

      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
