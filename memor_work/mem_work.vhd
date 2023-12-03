----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:28:47 11/29/2023 
-- Design Name: 
-- Module Name:    mem_work - Behavioral 
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
use ieee.numeric_std.all; 
use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_work is
	port(
	     clock            : IN  STD_LOGIC;
        reset            : IN  STD_LOGIC;
        en_boot          : IN  STD_LOGIC;                    -- enable boot module
        port_data_in     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- parallel data input
		  port_data_out    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- parallel data output
		  port_en_data_in  : IN  STD_LOGIC;                    -- enable signal for parallel data input
        port_en_data_out : IN  STD_LOGIC;                    -- enable signal for parallel data output
		  port_wr_data_out : out std_logic
	);
end mem_work;

architecture Behavioral of mem_work is
	
	component ram is
	port (
	clka: in std_logic;
	ena: in std_logic;
	wea: in std_logic_vector(0 downto 0);
	addra: in std_logic_vector(15 downto 0);
	dina: in std_logic_vector(7 downto 0);
	douta: out std_logic_vector(7 downto 0)
	);
   end component;

	component boot is
    PORT (
        clock            : IN  STD_LOGIC;
        reset            : IN  STD_LOGIC;
        en_boot          : IN  STD_LOGIC;                    -- enable boot module
        port_data_in     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- parallel data input
        port_data_out    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- parallel data output
        port_en_data_in  : IN  STD_LOGIC;                    -- enable signal for parallel data input
        port_en_data_out : IN  STD_LOGIC;                    -- enable signal for parallel data output
        port_wr_data_out : OUT STD_LOGIC;                    -- write signal for parallel data output

        mem_data_in  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);  -- parallel data input for program memory
        mem_data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);  -- parallel data output for program memory
        mem_addr     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- parallel addres for program memory
        mem_ena      : OUT STD_LOGIC;                     -- enable signal for read program memory
        mem_wea      : OUT STD_LOGIC                      -- enable signal for write program memory
    );
    end component;
	 
	signal salida_memoria :std_logic_vector(7 downto 0);
	signal escribir : std_logic;
	signal escritura: std_logic_vector(0 downto 0);
	signal entrada_memoria :std_logic_vector(7 downto 0);
	signal addr :std_logic_vector(15 downto 0);
	signal activar :std_logic;
	signal memory_in :std_logic_vector(7 downto 0);
	signal start_lectura : std_logic;
	
begin
	
	port_wr_data_out <= start_lectura;
	

	booty:boot
   port map (
        clock            => clock,
        reset            => reset,
        en_boot          => en_boot,                   
        port_data_in     => port_data_in, 
        port_data_out    => salida_memoria, 
        port_en_data_in  => port_en_data_in,                   
        port_en_data_out => port_en_data_out,          
        port_wr_data_out => start_lectura,                    
        mem_data_in  => memory_in,
        mem_data_out => entrada_memoria,
        mem_addr     => addr,
        mem_ena      => activar,                 
        mem_wea      => escritura(0)
    );
	 
	memory : ram 
	port map(
	clka => clock,
	ena => activar,
	wea => escritura,
	addra => addr,
	dina => entrada_memoria,
	douta => memory_in
	);

	port_data_out <= salida_memoria;

end Behavioral;

