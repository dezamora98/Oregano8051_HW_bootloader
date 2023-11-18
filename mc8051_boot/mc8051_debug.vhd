----------------------------------------------------------------------------------
-- Company: Cuba 
-- Engineer: Daniel Enrique Zamora Sifredo
-- 
-- Create Date:    05:50:13 11/05/2023 
-- Design Name: 
-- Module Name:    mc8051_debug - Behavioral 
-- Project Name: Oreganodebugger
-- Target Devices: 
--
-- Dependencies: Oregano8051
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY mc8051_debug IS
    PORT (
        clk     : IN  STD_LOGIC;
        reset   : IN  STD_LOGIC;
        tx_uart : OUT STD_LOGIC;
        rx_uart : IN  STD_LOGIC
    );
END ENTITY;

ARCHITECTURE Behavioral OF mc8051_debug IS
    COMPONENT mc8051_siu
        PORT (
            clk     : IN STD_LOGIC;                    --< system clock
            reset   : IN STD_LOGIC;                    --< system reset
            tf_i    : IN STD_LOGIC;                    --< timer1 overflow flag
            trans_i : IN STD_LOGIC;                    --< 1 activates transm.
            rxd_i   : IN STD_LOGIC;                    --< serial data input
            scon_i  : IN STD_LOGIC_VECTOR(5 DOWNTO 0); --< from SFR register
            --< bits 7 to 3
            sbuf_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0); --< data for transm.
            smod_i : IN STD_LOGIC;                    --< low(0)/high baudrate

            sbuf_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); --< received data 
            scon_o : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); --< to SFR register 
            --< bits 0 to 2
            rxdwr_o : OUT STD_LOGIC; --< rxd direction signal
            rxd_o   : OUT STD_LOGIC; --< mode0 data output
            txd_o   : OUT STD_LOGIC
        ); --< serial data output
    END COMPONENT;

    COMPONENT clk_50to12
        PORT (
            CLKIN_IN        : IN  STD_LOGIC;
            RST_IN          : IN  STD_LOGIC;
            CLKFX_OUT       : OUT STD_LOGIC;
            CLKIN_IBUFG_OUT : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk_12       : STD_LOGIC;
    SIGNAL ti_BR_115200 : STD_LOGIC;
    SIGNAL EN_tx        : STD_LOGIC;
    SIGNAL EN_rx        : STD_LOGIC;
    SIGNAL EN_RI        : STD_LOGIC;
    SIGNAL SMOD         : STD_LOGIC;
    SIGNAL sbuf_o       : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL sbuf_i       : STD_LOGIC_VECTOR(7 DOWNTO 0);

    --SCON
    SIGNAL RI  : STD_LOGIC;
    SIGNAL TI  : STD_LOGIC;
    SIGNAL RB8 : STD_LOGIC;
    SIGNAL TB8 : STD_LOGIC;
    SIGNAL REN : STD_LOGIC;
    SIGNAL SM  : STD_LOGIC_VECTOR(2 DOWNTO 0);
    --end SCON

BEGIN

    Inst_mc8051_siu : mc8051_siu
    PORT MAP(
        clk                => clk_12,
        reset              => reset,
        tf_i               => ti_BR_115200,
        trans_i            => EN_tx,
        rxd_i              => rx_uart,
        scon_i(5)          => EN_RI,
        scon_i(4 DOWNTO 2) => SM,
        scon_i(1)          => REN,
        scon_i(0)          => TB8,
        sbuf_i             => sbuf_i,
        smod_i             => SMOD,
        sbuf_o             => sbuf_o,
        scon_o(2)          => RB8,
        scon_o(1)          => TI,
        scon_o(0)          => RI,
        txd_o              => tx_uart
    );


END Behavioral;