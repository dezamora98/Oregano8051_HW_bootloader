--------------------------------------------------------------------------------
-- Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 12.4
--  \   \         Application : xaw2vhdl
--  /   /         Filename : clk_12mhz.vhd
-- /___/   /\     Timestamp : 12/01/2023 01:47:51
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: xaw2vhdl-st C:\\Documents and Settings\lester\Escritorio\OOOOOOO\memor_work\ipcore_dir\.\clk_12mhz.xaw C:\\Documents and Settings\lester\Escritorio\OOOOOOO\memor_work\ipcore_dir\.\clk_12mhz
--Design Name: clk_12mhz
--Device: xc3s1600e-4fg320
--
-- Module clk_12mhz
-- Generated by Xilinx Architecture Wizard
-- Written for synthesis tool: XST
-- Period Jitter (unit interval) for block DCM_SP_INST = 0.04 UI
-- Period Jitter (Peak-to-Peak) for block DCM_SP_INST = 3.62 ns

library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity clk_12mhz is
   port ( CLKIN_IN        : in    std_logic; 
          RST_IN          : in    std_logic; 
          CLKFX_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic);
end clk_12mhz;

architecture BEHAVIORAL of clk_12mhz is
   signal CLKIN_IBUFG     : std_logic;
   signal GND_BIT         : std_logic;
begin
   GND_BIT <= '0';
   CLKIN_IBUFG_OUT <= CLKIN_IBUFG;
   CLKIN_IBUFG_INST : IBUFG
      port map (I=>CLKIN_IN,
                O=>CLKIN_IBUFG);
   
   DCM_SP_INST : DCM_SP
   generic map( CLK_FEEDBACK => "NONE",
            CLKDV_DIVIDE => 6.0,
            CLKFX_DIVIDE => 25,
            CLKFX_MULTIPLY => 6,
            CLKIN_DIVIDE_BY_2 => FALSE,
            CLKIN_PERIOD => 20.000,
            CLKOUT_PHASE_SHIFT => "NONE",
            DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE => "LOW",
            DLL_FREQUENCY_MODE => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            FACTORY_JF => x"C080",
            PHASE_SHIFT => 0,
            STARTUP_WAIT => FALSE)
      port map (CLKFB=>GND_BIT,
                CLKIN=>CLKIN_IBUFG,
                DSSEN=>GND_BIT,
                PSCLK=>GND_BIT,
                PSEN=>GND_BIT,
                PSINCDEC=>GND_BIT,
                RST=>RST_IN,
                CLKDV=>open,
                CLKFX=>CLKFX_OUT,
                CLKFX180=>open,
                CLK0=>open,
                CLK2X=>open,
                CLK2X180=>open,
                CLK90=>open,
                CLK180=>open,
                CLK270=>open,
                LOCKED=>open,
                PSDONE=>open,
                STATUS=>open);
   
end BEHAVIORAL;

