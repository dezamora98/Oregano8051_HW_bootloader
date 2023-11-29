----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:05:13 11/28/2023 
-- Design Name: 
-- Module Name:    memory_work - Behavioral 
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

entity memory_work is
	PORT (
        clock            : IN  STD_LOGIC;
        reset            : IN  STD_LOGIC;
        en_boot          : IN  STD_LOGIC;                    -- enable boot module
        port_data_in     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- parallel data input
        port_en_data_in  : IN  STD_LOGIC;                    -- enable signal for parallel data input
        port_en_data_out : IN  STD_LOGIC                   -- enable signal for parallel data output
    );
end memory_work;

architecture Behavioral of memory_work is

	component boot IS
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
END component;

begin


end Behavioral;

