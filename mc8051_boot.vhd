library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use work.mc8051_p.all;


entity mc8051_boot is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        boot_en     : in std_logic;
        
        -- ROM Ctrl interface
            rom_data_i  : in  std_logic_vector(7 downto 0);
            rom_data_o  : out std_logic_vector(7 downto 0);
            rom_addr    : out std_logic_vector(15 downto 0);
            rom_en      : out std_logic;
            rom_wr      : out std_logic;
        -- end ROM Ctrl Interface

        -- Timer Ctrl interface
            tmod_i     : out  std_logic_vector(7 downto 0);  --< from SFR register
            tcon_tr1_i : out  std_logic;  			--< timer run 1
            reload_i   : out  std_logic_vector(7 downto 0);  --< to load counter
            wt_en_i    : out  std_logic;  			--< indicates reload
            wt_i       : out  std_logic_vector(1 downto 0);  --< reload which reg.
        -- end Timer Ctrl interface

        -- SIU Ctrl interface
            trans_i : out std_logic;  		    --< 1 activates transm.
            rxd_i   : out std_logic;  		    --< serial data input
            scon_i  : out std_logic_vector(5 downto 0);  --< from SFR register
                                --< bits 7 to 3
            sbuf_i  : out std_logic_vector(7 downto 0);  --< data for transm.
            smod_i  : out std_logic;  		    --< low(0)/high baudrate

            sbuf_o  : in std_logic_vector(7 downto 0);  --< received data 
            scon_o  : in std_logic_vector(2 downto 0);  --< to SFR register 
                            --< bits 0 to 2
            rxdwr_o : in std_logic;  	             --< rxd direction signal
            rxd_o   : in std_logic;  		     --< mode0 data output
            txd_o   : in std_logic;
        -- end  SIU Ctrl interface

        cpu_rst     : out std_logic                        -- enable CPU core

    );
end entity;

architecture rtl of mc8051_boot is
    
begin

    cpu_rst <= boot_en or reset;
    tmod_i <= "00010000";    -- tmr1 mode 2
    reload_i <= x"ff";       -- tmr1 autoreload for 625000bps in 12MHz fcpu;

    process (clk, reset)
    begin
        if reset = '1' then
            
        elsif rising_edge(clk) then
            
        end if;
    end process;


end architecture;

