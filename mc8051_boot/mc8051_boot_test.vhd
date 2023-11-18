----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:06:09 11/12/2023 
-- Design Name: 
-- Module Name:    mc8051_boot_test - rtl 
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
use work.
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mc8051_boot_test is
	port(
		clock   :   in  std_logic;
		reset   :   in  std_logic;
		uart_rx :   in  std_logic;
		uart_tx :   out std_logic
	);
end mc8051_boot_test;

architecture rtl of mc8051_boot_test is
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
	
	COMPONENT mc8051_boot
		PORT(
			clk : IN std_logic;
			reset : IN std_logic;
			boot_en : IN std_logic;
			rom_data_i : IN std_logic_vector(7 downto 0);
			sbuf_o : IN std_logic_vector(7 downto 0);
			scon_o : IN std_logic_vector(2 downto 0);          
			rom_data_o : OUT std_logic_vector(7 downto 0);
			rom_addr : OUT std_logic_vector(15 downto 0);
			rom_en : OUT std_logic;
			rom_wr : OUT std_logic;
			tmod_i : OUT std_logic_vector(7 downto 0);
			tcon_tr1_i : OUT std_logic;
			reload_i : OUT std_logic_vector(7 downto 0);
			wt_en_i : OUT std_logic;
			wt_i : OUT std_logic_vector(1 downto 0);
			trans : OUT std_logic;
			scon_i : OUT std_logic_vector(5 downto 0);
			sbuf_i : OUT std_logic_vector(7 downto 0);
			smod : OUT std_logic;
			cpu_rst : OUT std_logic
			);
	END COMPONENT;
	
	COMPONENT mc8051_rom
	  PORT (
		clka : IN STD_LOGIC;
		rsta : IN STD_LOGIC;
		ena : IN STD_LOGIC;
		wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;
	
	COMPONENT clk_50to12
	PORT(
		CLKIN_IN : IN std_logic;
		RST_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic
		);
	END COMPONENT;

    attribute dont_touch : boolean;
    attribute dont_touch of mc8051_rom: component is true;
    attribute dont_touch of mc8051_boot: component is true;
    attribute dont_touch of mc8051_siu: component is true;
    attribute dont_touch of mc8051_tmrctr: component is true;

    
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
    signal reload   : std_logic_vector(7 downto 0);
    signal wt       : std_logic_vector(1 downto 0);
    signal wt_en    : std_logic;
	signal tf1		: std_logic;

    -- ROM Ctrl interface
    signal rom_data_i  :  std_logic_vector(7 downto 0);
    signal rom_data_o  :  std_logic_vector(7 downto 0);
    signal rom_addr    :  std_logic_vector(15 downto 0);
    signal rom_en      :  std_logic;
    signal rom_wr      :  std_logic;

    -- core signal
    signal clock_12 : std_logic;
	signal cpu_rst	: std_logic;

begin

    i_mc8051_siu : mc8051_siu
    port map (
        clk       => clock_12,        -- SIUs inputs
        reset     => reset,

        tf_i      => tf1,
        trans_i   => trans,
        rxd_i     => uart_rx,
        scon_i    => scon_i,
        sbuf_i    => sbuf_i,
        smod_i    => smod,
                                    -- SIUs outputs
        sbuf_o    => sbuf_o,
        scon_o    => scon_o,
        rxdwr_o   => open,
        rxd_o     => open,
        txd_o     => uart_tx
    );

    

    i_mc8051_tmrctr : mc8051_tmrctr
    port map (
        clk        => clock_12,       -- tmr_ctr inputs
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
                                -- tmr_ctr outputs
        th0_o      => open,
        tl0_o      => open,
        th1_o      => open,
        tl1_o      => open,
        tf0_o      => open,
        tf1_o      => tf1
    );

    i_mc8051_boot: mc8051_boot 
    port map(
        clk => clock_12,
        reset => reset,
        boot_en => '1',
        
        rom_data_i => rom_data_i,
        rom_data_o => rom_data_o,
        rom_addr => rom_addr,
        rom_en => rom_en,
        rom_wr => rom_wr,

        tmod_i => tmod,
        tcon_tr1_i => tcon_tr1,
        reload_i => reload,
        wt_en_i => wt_en,
        wt_i => wt,

        trans => trans,
        scon_i => scon_i,
        sbuf_i => sbuf_i,
        smod => smod,
        sbuf_o => sbuf_o,
        scon_o => scon_o,
        
        cpu_rst => cpu_rst
    );
	
	i_mc8051_rom :  mc8051_rom
	port map (
		clka => clock_12,
		rsta => reset,
		ena => rom_en,
		wea(0) => rom_wr,
		addra => rom_addr,
		dina => rom_data_o,
		douta => rom_data_i
	);

	i_clk_50to12: clk_50to12 
	port map(
		CLKIN_IN => clock,
		RST_IN => reset,
		CLKFX_OUT => clock_12
	);    

end rtl;

