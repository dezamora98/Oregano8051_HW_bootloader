----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:32:33 12/01/2023 
-- Design Name: 
-- Module Name:    bootloader - Behavioral 
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
--use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bootloader is
port(
	clock : in std_logic;
	reset : in std_logic;
	en_boot: in std_logic;
	uart_rx: in std_logic;
	uart_tx: out std_logic
);
end bootloader;

architecture Behavioral of bootloader is
	
	TYPE state_type IS (inicio, conf_timer_l, conf_timer_h, conf_PS, program);

   SIGNAL state : state_type := inicio;
	
	signal next_state : state_type;
	
	component mem_work
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
end component;
	
	component mc8051_siu
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            tf_i    : in  std_logic;
            trans_i : in  std_logic;
            rxd_i   : in  std_logic;
            scon_i  : in  std_logic_vector(5 downto 0);
            sbuf_i  : in  std_logic_vector(7 downto 0);
            smod_i  : in  std_logic;
            sbuf_o  : out std_logic_vector(7 downto 0);
            scon_o  : out std_logic_vector(2 downto 0);
            rxdwr_o : out std_logic;
            rxd_o   : out std_logic;
            txd_o   : out std_logic
        );
  end component;

    component mc8051_tmrctr
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            int0_i     : in  std_logic;
            int1_i     : in  std_logic;
            t0_i       : in  std_logic;
            t1_i       : in  std_logic;
            tmod_i     : in  std_logic_vector(7 downto 0);
            tcon_tr0_i : in  std_logic;
            tcon_tr1_i : in  std_logic;
            reload_i   : in  std_logic_vector(7 downto 0);
            wt_en_i    : in  std_logic;
            wt_i       : in  std_logic_vector(1 downto 0);
            th0_o      : out std_logic_vector(7 downto 0);
            tl0_o      : out std_logic_vector(7 downto 0);
            th1_o      : out std_logic_vector(7 downto 0);
            tl1_o      : out std_logic_vector(7 downto 0);
            tf0_o      : out std_logic;
            tf1_o      : out std_logic
        );
    end component;
	

	component clk_12mhz
   port ( CLKIN_IN        : in    std_logic;  
          CLKFX_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic);
   end component;

	-- signals to and from the SIUs
    signal scon_RI  : std_logic_vector(0 downto 0);
    signal scon_SM  : std_logic_vector(2 downto 0);
    signal scon_REN : std_logic_vector(0 downto 0);
    signal scon_TB8 : std_logic_vector(0 downto 0);
    signal scon_RB8 : std_logic_vector(0 downto 0);
    signal scon_TIF : std_logic_vector(0 downto 0);
    signal scon_RIF : std_logic_vector(0 downto 0);

    signal scon_i   : std_logic_vector(5 downto 0);
    signal scon_o   : std_logic_vector(2 downto 0);

    signal trans    : std_logic;
    signal sbuf_i   : std_logic_vector(7 downto 0);
    signal smod     : std_logic;
    signal sbuf_o   : std_logic_vector(7 downto 0);
        
    -- signals to and from the timer/counters
    signal tcon_tr1 : std_logic;
    signal tmod     : std_logic_vector(7 downto 0);
    signal reload   : std_logic_vector(7 downto 0):=x"00";
    signal wt       : std_logic_vector(1 downto 0):="00";
    signal wt_en    : std_logic:='0';
	 signal tf1		  : std_logic;

	 signal reloj12 : std_logic;

begin

	reloj:clk_12mhz
   port map( CLKIN_IN     => clock, 
          CLKFX_OUT       => reloj12,
          CLKIN_IBUFG_OUT => open);
   

	

	memory_work: mem_work
	port map(
	     clock            => reloj12,
        reset            => reset,
        en_boot          => en_boot,                    -- enable boot module
        port_data_in     => sbuf_o, -- parallel data input
		  port_data_out    => sbuf_i, -- parallel data output
		  port_en_data_in  => scon_o(0),                    -- enable signal for parallel data input
        port_en_data_out => scon_o(1),                    -- enable signal for parallel data output
		  port_wr_data_out => trans
	);


	puerto_serie : mc8051_siu
        port map(
            clk     => reloj12,
            reset   => reset,
            tf_i    => tf1,
            trans_i => trans,
            rxd_i   => uart_rx,
            scon_i  => scon_i,
            sbuf_i  => sbuf_i,
            smod_i  => smod,
				
            sbuf_o  => sbuf_o,
            scon_o  => scon_o,
            rxdwr_o => open,
            rxd_o   => open,
            txd_o   => uart_tx
        );

    timer: mc8051_tmrctr
        port map(
            clk        => reloj12,
            reset      => reset,
            int0_i     => '0',
            int1_i     => '0',
            t0_i       => '0',
            t1_i       => '0',
            tmod_i     => tmod,
            tcon_tr0_i => '0',
            tcon_tr1_i => tcon_tr1,
            reload_i   => reload,
            wt_en_i    => wt_en,
            wt_i       => wt,
				
            th0_o      => open,
            tl0_o      => open,
            th1_o      => open,
            tl1_o      => open,
            tf0_o      => open,
            tf1_o      => tf1
        );
		  
	sync : PROCESS (reloj12, reset)
    BEGIN
        IF reset = '1' THEN
            state    <= inicio;
        ELSIF (reloj12'event AND reloj12 = '1') THEN
            state    <= next_state;
        END IF;
    END PROCESS; -- sync
		  
		
	next_state_decode : PROCESS (state, en_boot, tmod, wt, wt_en, reload , trans, scon_i, smod)
    BEGIN

        --next_state   <= state;
		  
		  case (state) is
		  
		  when inicio =>
		  if en_boot = '1' then
				next_state <= conf_timer_l;
		  else 
				next_state <= inicio;
		  end if;
		  
		  when conf_timer_l =>
			   tmod <= x"20";
				wt <= "01";
				wt_en <= '1';
				reload <= x"FE";
				next_state <= conf_timer_h;
			
			when conf_timer_h =>
				wt <= "11";
				wt_en <= '1';
				reload <= x"FF";
				next_state <= conf_PS;
				
			
			when conf_PS =>
				wt_en <= '0';
				scon_i <= "001010";
				smod <= '0';
				tcon_tr1 <= '1';
				next_state <= program;
				
			when program =>
				if en_boot = '1' then
					next_state <= program;
				else
					next_state <= inicio;
				end if;
			
			when others =>
				next_state <= inicio;
			
		end case;
	end process;
			
			
			
			
			
end Behavioral;

