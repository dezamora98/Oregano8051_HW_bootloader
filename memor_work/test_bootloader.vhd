--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   06:55:14 12/01/2023
-- Design Name:   
-- Module Name:   C:/Documents and Settings/lester/Escritorio/OOOOOOO/memor_work/test_bootloader.vhd
-- Project Name:  memor_work
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bootloader
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
 
ENTITY test_bootloader IS
END test_bootloader;
 
ARCHITECTURE behavior OF test_bootloader IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bootloader
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         en_boot : IN  std_logic;
         uart_rx : IN  std_logic;
         uart_tx : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '1';
   signal en_boot : std_logic := '0';
   signal uart_rx : std_logic := '0';

 	--Outputs
   signal uart_tx : std_logic;

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bootloader PORT MAP (
          clock => clock,
          reset => reset,
          en_boot => en_boot,
          uart_rx => uart_rx,
          uart_tx => uart_tx
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
      wait for 1 us;	
		reset <= '0';
		
		
		wait for 350 ns;
		en_boot <= '1';
	
--inicializacion
	
		wait for 2 us;
		uart_rx <= '1';
		
		wait for 6 us;
		uart_rx <= '0';
		
		wait for 290 us;
		uart_rx <= '1';
				
		
--envio del comando

		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '1';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '0';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
     		
--envio del size
		
		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '0';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '1';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
		
--envio de addr_h

		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '0';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '0';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
		
--envio de addr_l
		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '0';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '1';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';

--envio de code

		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '0';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '0';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
		
--envio de datos
		--dato 1
		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '0';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '0';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '1';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
		
		--dato 2
		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '0';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '1';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '1';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
		
		--dato 3
		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '1';
		
		wait for 32 us;--D1
		uart_rx <= '1';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '0';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
		
		--dato 4
		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '1';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '0';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
		
		--dato 5
		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '0';
		
		wait for 32 us;--D1
		uart_rx <= '1';
		
		wait for 32 us;--D2
		uart_rx <= '1';
		
		wait for 32 us;--D3
		uart_rx <= '0';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '1';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
		
		--dato 6
		
		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '0';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '0';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
		
		--dato 7
		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '0';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '1';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '1';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';
		
		--dato 8
		wait for 20 us;--bit de start
		uart_rx <= '0';
		
		wait for 32 us;--D0
		uart_rx <= '0';
		
		wait for 32 us;--D1
		uart_rx <= '0';
		
		wait for 32 us;--D2
		uart_rx <= '0';
		
		wait for 32 us;--D3
		uart_rx <= '0';
		
		wait for 32 us;--D4
		uart_rx <= '0';
		
		wait for 32 us;--D5
		uart_rx <= '0';
		
		wait for 32 us;--D6
		uart_rx <= '0';
		
		wait for 32 us;--D7
		uart_rx <= '0';
		
		wait for 32 us;--bit de parada
		uart_rx <= '1';

      wait;
   end process;

END;
