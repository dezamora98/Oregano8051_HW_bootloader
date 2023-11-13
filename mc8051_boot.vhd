library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 

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
            trans   : out std_logic;  		    --< 1 activates transm.
            scon_i  : out std_logic_vector(5 downto 0);  --< from SFR register
                                --< bits 7 to 3
            sbuf_i  : out std_logic_vector(7 downto 0);  --< data for transm.
            smod    : out std_logic;  		    --< low(0)/high baudrate

            sbuf_o  : in std_logic_vector(7 downto 0);  --< received data 
            scon_o  : in std_logic_vector(2 downto 0);  --< to SFR register 
                            --< bits 0 to 2

        -- CPU signal
        cpu_rst     : out std_logic                        -- enable CPU core

    );
end entity;

architecture rtl of mc8051_boot is
    signal scon_RI  : std_logic_vector(0 downto 0);
    signal scon_SM  : std_logic_vector(2 downto 0);
    signal scon_REN : std_logic_vector(0 downto 0);
    signal scon_TB8 : std_logic_vector(0 downto 0);
    signal scon_RB8 : std_logic;
    signal scon_TIF : std_logic;
    signal scon_RIF : std_logic;
	
    type state_type is (st_init, st_tl1_write, st_th1_write);
    signal state, next_state : state_type := st_init; 
begin
    scon_i <= (scon_RI & scon_SM & scon_REN & scon_TB8);
    scon_RB8 <= scon_o(2);
    scon_TIF <= scon_o(1);
    scon_RIF <= scon_o(0);

    cpu_rst <= boot_en or reset;
    tmod_i <= "00010000";    -- tmr1 mode 2
    reload_i <= x"ff";       -- tmr1 autoreload for 625000bps in 12MHz fcpu;
    trans <= '1';

    wt_i <= "01" when state = st_tl1_write else
            "11" when state = st_th1_write else
            "00";

              
    --Insert the following in the architecture after the begin keyword
    SYNC_PROC: process (clk)
    begin
        if (clk'event and clk = '1') then
            if (reset = '1') then
                state <= st_init;
            else
                state <= next_state;
            end if;        
        end if;
    end process;
    
    
    NEXT_STATE_DECODE: process (state, sbuf_o, scon_o)
    begin

        next_state <= state;  --default is to stay in current state
        
        --case (state) is
        --    when st_init =>
        --        if scon_o(1) = '1' then
        --        end if;
		--	
        --end case;      
    end process;
             


end architecture;

