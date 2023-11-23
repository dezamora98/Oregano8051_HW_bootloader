--------------------------------------------------------------------------------
-- Engineer: Daniel Enrique Zamora Sifredo
--
-- Create Date:   20:11:25 11/18/2023
-- Design Name:   
-- Project Name:  XC3S1600E_8051LAB
--
-- VHDL Test Bench Created by ISE for module: boot
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
 
ENTITY boot_tb IS
END boot_tb;
 
ARCHITECTURE behavior OF boot_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT boot
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         en_boot : IN  std_logic;
         port_data_in : IN  std_logic_vector(7 downto 0);
         port_data_out : OUT  std_logic_vector(7 downto 0);
         port_en_data_in : IN  std_logic;
         port_en_data_out : IN  std_logic;
         port_wr_data_out : OUT  std_logic;
         mem_data_in : IN  std_logic_vector(7 downto 0);
         mem_data_out : OUT  std_logic_vector(7 downto 0);
         mem_addr : OUT  std_logic_vector(15 downto 0);
         mem_ena : OUT  std_logic;
         mem_wea : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal en_boot : std_logic := '0';
   signal port_data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal port_en_data_in : std_logic := '0';
   signal port_en_data_out : std_logic := '0';
   signal mem_data_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal port_data_out : std_logic_vector(7 downto 0);
   signal port_wr_data_out : std_logic;
   signal mem_data_out : std_logic_vector(7 downto 0);
   signal mem_addr : std_logic_vector(15 downto 0);
   signal mem_ena : std_logic = '0';
   signal mem_wea : std_logic = '0';

   -- Clock period definitions
   constant clock_period : time := 80 ns;

   type data_array is array( 0 to 8 ) of std_logic_vector(7 downto 0);

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: boot PORT MAP (
          clock => clock,
          reset => reset,
          en_boot => en_boot,
          port_data_in => port_data_in,
          port_data_out => port_data_out,
          port_en_data_in => port_en_data_in,
          port_en_data_out => port_en_data_out,
          port_wr_data_out => port_wr_data_out,
          mem_data_in => mem_data_in,
          mem_data_out => mem_data_out,
          mem_addr => mem_addr,
          mem_ena => mem_ena,
          mem_wea => mem_wea
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
      wait for clock_period*2;
      reset <= '1';
      wait for clock_period*2;
      -- insert stimulus here 
      en_boot <= '1';



      assert false report “Test complete”;
      wait;
   end process;

END;
