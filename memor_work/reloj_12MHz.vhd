----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:52:29 12/01/2023 
-- Design Name: 
-- Module Name:    reloj_12MHz - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reloj_12MHz is
port(
	clk : in std_logic;
	salida12: out std_logic
	);
	
end reloj_12MHz;

architecture Behavioral of reloj_12MHz is

	component clk_12mhz is
   port ( CLKIN_IN        : in    std_logic; 
          CLKFX_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic);
   end component;
	
	signal reloj : std_logic;

begin
	relojito :clk_12mhz
		port map(
		CLKIN_IN        => clk,
      CLKFX_OUT       => reloj,
      CLKIN_IBUFG_OUT => open
		);
		
		salida12 <= reloj;

end Behavioral;

