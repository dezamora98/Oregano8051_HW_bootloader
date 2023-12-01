--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:01:35 12/01/2023
-- Design Name:   
-- Module Name:   C:/Documents and Settings/lester/Escritorio/OOOOOOO/memor_work/testreloj12.vhd
-- Project Name:  memor_work
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reloj_12MHz
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
 
ENTITY testreloj12 IS
END testreloj12;
 
ARCHITECTURE behavior OF testreloj12 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reloj_12MHz
    PORT(
         clk : IN  std_logic;
         salida12 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal salida12 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reloj_12MHz PORT MAP (
          clk => clk,
          salida12 => salida12
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
