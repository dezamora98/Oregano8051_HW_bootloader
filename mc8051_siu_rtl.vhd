-------------------------------------------------------------------------------
--                                                                           --
--          X       X   XXXXXX    XXXXXX    XXXXXX    XXXXXX      X          --
--          XX     XX  X      X  X      X  X      X  X           XX          --
--          X X   X X  X         X      X  X      X  X          X X          --
--          X  X X  X  X         X      X  X      X  X         X  X          --
--          X   X   X  X          XXXXXX   X      X   XXXXXX      X          --
--          X       X  X         X      X  X      X         X     X          --
--          X       X  X         X      X  X      X         X     X          --
--          X       X  X      X  X      X  X      X         X     X          --
--          X       X   XXXXXX    XXXXXX    XXXXXX    XXXXXX      X          --
--                                                                           --
--                                                                           --
--                       O R E G A N O   S Y S T E M S                       --
--                                                                           --
--                            Design & Consulting                            --
--                                                                           --
-------------------------------------------------------------------------------
--                                                                           --
--         Web:           http://www.oregano.at/                             --
--                                                                           --
--         Contact:       mc8051@oregano.at                                  --
--                                                                           --
-------------------------------------------------------------------------------
--                                                                           --
--  MC8051 - VHDL 8051 Microcontroller IP Core                               --
--  Copyright (C) 2001 OREGANO SYSTEMS                                       --
--                                                                           --
--  This library is free software; you can redistribute it and/or            --
--  modify it under the terms of the GNU Lesser General Public               --
--  License as published by the Free Software Foundation; either             --
--  version 2.1 of the License, or (at your option) any later version.       --
--                                                                           --
--  This library is distributed in the hope that it will be useful,          --
--  but WITHOUT ANY WARRANTY; without even the implied warranty of           --
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        --
--  Lesser General Public License for more details.                          --
--                                                                           --
--  Full details of the license can be found in the file LGPL.TXT.           --
--                                                                           --
--  You should have received a copy of the GNU Lesser General Public         --
--  License along with this library; if not, write to the Free Software      --
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA  --
--                                                                           --
-------------------------------------------------------------------------------
--
--
--         Author:                 Roland H�ller
--
--         Filename:               mc8051_siu_rtl.vhd
--
--         Date of Creation:       Mon Aug  9 12:14:48 1999
--
--         Version:                $Revision: 1.10 $
--
--         Date of Latest Version: $Date: 2010-03-24 10:20:48 $
--
--
--         Description: Serial interface unit for the mc8051 microcontroller.
--
--
--
--
-------------------------------------------------------------------------------
ARCHITECTURE rtl OF mc8051_siu IS

    SIGNAL s_rxpre_count : unsigned(5 DOWNTO 0); -- Receive prescaler
    SIGNAL s_txpre_count : unsigned(5 DOWNTO 0); -- Transmit prescaler
    SIGNAL s_m0_shift_en : STD_LOGIC;            -- masks out every twelfth
    -- rising edge of clk
    SIGNAL s_m2_rxshift_en  : STD_LOGIC;             -- mode 2 shift enable
    SIGNAL s_m13_rxshift_en : STD_LOGIC;             -- mode 1 and 3 shift enable
    SIGNAL s_m2_txshift_en  : STD_LOGIC;             -- mode 2 shift enable
    SIGNAL s_m13_txshift_en : STD_LOGIC;             -- mode 1 and 3 shift enable
    SIGNAL s_ff0            : STD_LOGIC;             -- flipflop for edge dedection
    SIGNAL s_ff1            : STD_LOGIC;             -- flipflop for edge dedection
    SIGNAL s_tf             : STD_LOGIC;             -- synchronised timer flag
    SIGNAL s_mode           : unsigned(1 DOWNTO 0);  -- mode
    SIGNAL s_sm2            : STD_LOGIC;             -- multi processor comm. bit
    SIGNAL s_detect         : STD_LOGIC;             -- indicates start of recept. 
    SIGNAL s_ren            : STD_LOGIC;             -- receive enable
    SIGNAL s_rxd_val        : STD_LOGIC;             -- received data bit
    SIGNAL s_txdm0          : STD_LOGIC;             -- shift clock for m0
    SIGNAL s_ri             : STD_LOGIC;             -- external receive interrupt 
    SIGNAL s_trans          : STD_LOGIC;             -- enable transmission 
    SIGNAL s_recv_done      : STD_LOGIC;             -- receive interrupt
    SIGNAL s_tran_done      : STD_LOGIC;             -- transmit interrupt
    SIGNAL s_rb8            : STD_LOGIC;             -- 8th data bit
    SIGNAL s_tb8            : STD_LOGIC;             -- 8th data bit
    SIGNAL s_recv_state     : unsigned(3 DOWNTO 0);  -- state reg. of receive unit
    SIGNAL s_tran_state     : unsigned(3 DOWNTO 0);  -- state reg. of transmit unit
    SIGNAL s_rxd_ff0        : STD_LOGIC;             -- sample flip-flop
    SIGNAL s_rxd_ff1        : STD_LOGIC;             -- sample flip-flop
    SIGNAL s_rxd_ff2        : STD_LOGIC;             -- sample flip-flop
    SIGNAL s_det_ff0        : STD_LOGIC;             -- rec. detect flip-flop
    SIGNAL s_det_ff1        : STD_LOGIC;             -- rec. detect flip-flop
    SIGNAL s_tran_sh        : unsigned(10 DOWNTO 0); -- transmission shift register
    SIGNAL s_recv_sh        : unsigned(7 DOWNTO 0);  -- reception shift register
    SIGNAL s_recv_buf       : unsigned(7 DOWNTO 0);  -- reception buffer register
    SIGNAL s_rxm13_ff0      : STD_LOGIC;             -- generates an enable singal
    SIGNAL s_rxm13_ff1      : STD_LOGIC;             -- generates an enable singal
    SIGNAL s_txm13_ff0      : STD_LOGIC;             -- generates an enable singal
    SIGNAL s_txm13_ff1      : STD_LOGIC;             -- generates an enable singal

BEGIN -- architecture rtl

    s_mode(1) <= scon_i(4); -- defines the 4 operating modes
    s_mode(0) <= scon_i(3);
    s_ren     <= scon_i(1); -- receive enable
    s_sm2     <= scon_i(2); -- 1 time or half time baud rate
    s_tb8     <= scon_i(0); -- 9th data bit for transmission
    s_ri      <= scon_i(5); -- the receive interrupt bit of the
    -- control unit
    sbuf_o    <= STD_LOGIC_VECTOR(s_recv_buf); -- the receive buffer output
    scon_o(0) <= s_recv_done;                  -- set when reception is completed
    scon_o(1) <= s_tran_done;                  -- set when transmission is completed
    scon_o(2) <= s_rb8;                        -- 9th data bit of reception  

    -------------------------------------------------------------------------------
    -- The two flip flops are updated every rising clock edge of clk.
    -- If a rising edge
    -- on the port tf_i is dedected the signal s_tf is set to 1 for one period.
    --
    -- The transmission start signal s_trans is generated and held high till
    -- the statemachine has been launched with its first shift.
    --
    -- The shift clock for mode0 is generated. It toggles with the half
    -- s_m0_shift_en rate.

    s_tf <= '1' WHEN (s_ff0 = '1' AND s_ff1 = '0') ELSE
            '0';

    p_sample_tf : PROCESS (clk,
        reset)

    BEGIN

        IF reset = '1' THEN
            s_ff0   <= '0';
            s_ff1   <= '0';
            s_trans <= '0';
        ELSE
            IF clk'event AND clk = '1' THEN
                s_ff0 <= tf_i;
                s_ff1 <= s_ff0;

                IF trans_i = '1' THEN
                    s_trans <= '1';
                ELSE
                    CASE s_mode IS
                        WHEN ("00") =>
                            IF s_m0_shift_en = '1' THEN
                                s_trans <= '0';
                            END IF;
                        WHEN ("01") =>
                            IF s_m13_txshift_en = '1' THEN
                                s_trans <= '0';
                            END IF;
                        WHEN ("10") =>
                            IF s_m2_txshift_en = '1' THEN
                                s_trans <= '0';
                            END IF;
                        WHEN OTHERS =>
                            IF s_m13_txshift_en = '1' THEN
                                s_trans <= '0';
                            END IF;
                    END CASE;
                END IF;
            END IF;
        END IF;

    END PROCESS p_sample_tf;

    -------------------------------------------------------------------------------
    -- The register s_rxpre_count is driven with the system clock clk. So a
    -- good enable signal (which is stable when clk has its rising edge) can be
    -- derived to mask out every pulse of clk needed.
    -- s_m0_shift_en activates every twelfth clock cycle
    -- s_m2_shift_en activates baud rates of 1/32 or 1/64 the clock frequenzy
    -- depending on signal smod_i
    -- s_m13_shift_en activates baud rates depending on timer/counter1 flag

    s_m0_shift_en <= '1' WHEN s_txpre_count(3 DOWNTO 0) = conv_unsigned(11, 5)
                     ELSE
                     '0';

    s_m2_rxshift_en <= '1' WHEN (s_rxpre_count(4 DOWNTO 0) = conv_unsigned(31, 5)
                       AND smod_i = '1') OR
                       (s_rxpre_count = conv_unsigned(63, 6)
                       AND smod_i = '0')
                       ELSE
                       '0';
    s_m13_rxshift_en <= '1' WHEN s_rxm13_ff0 = '1' AND s_rxm13_ff1 = '0'
                        ELSE
                        '0';

    s_m2_txshift_en <= '1' WHEN (s_txpre_count(4 DOWNTO 0) = conv_unsigned(31, 5)
                       AND smod_i = '1') OR
                       (s_txpre_count = conv_unsigned(63, 6)
                       AND smod_i = '0')
                       ELSE
                       '0';
    s_m13_txshift_en <= '1' WHEN s_txm13_ff0 = '1' AND s_txm13_ff1 = '0'
                        ELSE
                        '0';

    p_divide_clk : PROCESS (clk, reset)

    BEGIN

        IF reset = '1' THEN
            s_rxpre_count <= conv_unsigned(0, 6);
            s_txpre_count <= conv_unsigned(0, 6);
            s_rxm13_ff0   <= '0';
            s_rxm13_ff1   <= '0';
            s_txm13_ff0   <= '0';
            s_txm13_ff1   <= '0';
        ELSE
            IF clk'event AND clk = '1' THEN

                s_rxm13_ff1 <= s_rxm13_ff0;
                s_txm13_ff1 <= s_txm13_ff0;

                IF trans_i = '1' THEN
                    s_txpre_count <= conv_unsigned(0, 6);
                ELSE
                    IF s_mode = conv_unsigned(0, 2) THEN
                        s_txpre_count <= s_txpre_count + conv_unsigned(1, 1);
                        IF s_txpre_count = conv_unsigned(11, 6) THEN
                            s_txpre_count <= conv_unsigned(0, 6);
                        END IF;
                    ELSIF s_mode = conv_unsigned(2, 2) THEN
                        s_txpre_count <= s_txpre_count + conv_unsigned(1, 1);
                    ELSE
                        IF s_tf = '1' THEN
                            s_txpre_count <= s_txpre_count + conv_unsigned(1, 1);
                        END IF;
                    END IF;
                END IF;

                IF s_detect = '1' THEN
                    s_rxpre_count <= conv_unsigned(0, 6);
                ELSE
                    IF s_mode = conv_unsigned(0, 2) THEN
                        s_rxpre_count <= s_rxpre_count + conv_unsigned(1, 1);
                        IF s_rxpre_count = conv_unsigned(11, 6) THEN
                            s_rxpre_count <= conv_unsigned(0, 6);
                        END IF;
                    ELSIF s_mode = conv_unsigned(2, 2) THEN
                        s_rxpre_count <= s_rxpre_count + conv_unsigned(1, 1);
                    ELSE
                        IF s_tf = '1' THEN
                            s_rxpre_count <= s_rxpre_count + conv_unsigned(1, 1);
                        END IF;
                    END IF;
                END IF;

                IF smod_i = '1' THEN
                    IF s_rxpre_count(3 DOWNTO 0) = conv_unsigned(15, 4) THEN
                        s_rxm13_ff0 <= '1';
                    ELSE
                        s_rxm13_ff0 <= '0';
                    END IF;
                ELSE
                    IF s_rxpre_count(4 DOWNTO 0) = conv_unsigned(31, 5) THEN
                        s_rxm13_ff0 <= '1';
                    ELSE
                        s_rxm13_ff0 <= '0';
                    END IF;
                END IF;

                IF smod_i = '1' THEN
                    IF s_txpre_count(3 DOWNTO 0) = conv_unsigned(15, 4) THEN
                        s_txm13_ff0 <= '1';
                    ELSE
                        s_txm13_ff0 <= '0';
                    END IF;
                ELSE
                    IF s_txpre_count(4 DOWNTO 0) = conv_unsigned(31, 5) THEN
                        s_txm13_ff0 <= '1';
                    ELSE
                        s_txm13_ff0 <= '0';
                    END IF;
                END IF;

            END IF;
        END IF;

    END PROCESS p_divide_clk;

    -------------------------------------------------------------------------------
    -- This section samples the serial input for data detection, that is a
    -- 1-to-0 transition at rxd in state "0000".
    -- In all other states this unit reads the data bits depending on the baud
    -- rate. In mode0 this section is not active.

    s_detect <= '1' WHEN s_det_ff0 = '0' AND s_det_ff1 = '1' ELSE
                '0';
    s_rxd_val <= '1' WHEN (s_rxd_ff0 = '1' AND s_rxd_ff1 = '1') OR
                 (s_rxd_ff0 = '1' AND s_rxd_ff2 = '1') OR
                 (s_rxd_ff1 = '1' AND s_rxd_ff2 = '1') ELSE
                 '0';

    p_sample_rx : PROCESS (clk,
        reset)

    BEGIN
        IF reset = '1' THEN
            s_rxd_ff0 <= '0';
            s_rxd_ff1 <= '0';
            s_rxd_ff2 <= '0';
            s_det_ff0 <= '0';
            s_det_ff1 <= '0';
        ELSE
            IF clk'event AND clk = '1' THEN
                IF s_recv_state = conv_unsigned(0, 4) THEN -- state "0000" means
                    IF s_ren = '1' THEN -- to listen for a 1 to 0
                        CASE s_mode IS -- transition
                            WHEN ("01") | ("11") =>
                                IF smod_i = '1' THEN
                                    IF s_tf = '1' THEN
                                        s_det_ff0 <= rxd_i;
                                        s_det_ff1 <= s_det_ff0;
                                    END IF;
                                ELSE
                                    IF s_rxpre_count(0) = '1' THEN
                                        s_det_ff0 <= rxd_i;
                                        s_det_ff1 <= s_det_ff0;
                                    END IF;
                                END IF;
                            WHEN ("10") =>
                                IF smod_i = '1' THEN
                                    IF s_rxpre_count(0) = '1' THEN
                                        s_det_ff0 <= rxd_i;
                                        s_det_ff1 <= s_det_ff0;
                                    END IF;
                                ELSE
                                    IF s_rxpre_count(1) = '1' THEN
                                        s_det_ff0 <= rxd_i;
                                        s_det_ff1 <= s_det_ff0;
                                    END IF;
                                END IF;
                            WHEN OTHERS =>
                                NULL;
                        END CASE;
                    ELSE
                        s_det_ff0 <= '0';
                        s_det_ff1 <= '0';
                    END IF;
                ELSE -- in all other states
                    s_det_ff0 <= '0';
                    s_det_ff1 <= '0';
                    IF s_ren = '1' THEN -- sample for data bits
                        CASE s_mode IS
                            WHEN ("01") | ("11") =>
                                IF smod_i = '1' THEN
                                    IF s_rxpre_count(3 DOWNTO 0) = conv_unsigned(7, 4) OR
                                        s_rxpre_count(3 DOWNTO 0) = conv_unsigned(8, 4) OR
                                        s_rxpre_count(3 DOWNTO 0) = conv_unsigned(9, 4) THEN
                                        s_rxd_ff0 <= rxd_i;
                                        s_rxd_ff1 <= s_rxd_ff0;
                                        s_rxd_ff2 <= s_rxd_ff1;
                                    END IF;
                                ELSE
                                    IF s_rxpre_count(4 DOWNTO 0) = conv_unsigned(14, 5) OR
                                        s_rxpre_count(4 DOWNTO 0) = conv_unsigned(16, 5) OR
                                        s_rxpre_count(4 DOWNTO 0) = conv_unsigned(18, 5) THEN
                                        s_rxd_ff0 <= rxd_i;
                                        s_rxd_ff1 <= s_rxd_ff0;
                                        s_rxd_ff2 <= s_rxd_ff1;
                                    END IF;
                                END IF;
                            WHEN ("10") =>
                                IF smod_i = '1' THEN
                                    IF s_rxpre_count(4 DOWNTO 0) = conv_unsigned(14, 5) OR
                                        s_rxpre_count(4 DOWNTO 0) = conv_unsigned(16, 5) OR
                                        s_rxpre_count(4 DOWNTO 0) = conv_unsigned(18, 5) THEN
                                        s_rxd_ff0 <= rxd_i;
                                        s_rxd_ff1 <= s_rxd_ff0;
                                        s_rxd_ff2 <= s_rxd_ff1;
                                    END IF;
                                ELSE
                                    IF s_rxpre_count(5 DOWNTO 0) = conv_unsigned(28, 6) OR
                                        s_rxpre_count(5 DOWNTO 0) = conv_unsigned(32, 6) OR
                                        s_rxpre_count(5 DOWNTO 0) = conv_unsigned(36, 6) THEN
                                        s_rxd_ff0 <= rxd_i;
                                        s_rxd_ff1 <= s_rxd_ff0;
                                        s_rxd_ff2 <= s_rxd_ff1;
                                    END IF;
                                END IF;
                            WHEN OTHERS =>
                                NULL;
                        END CASE;
                    END IF;
                END IF;
            END IF;
        END IF;

    END PROCESS p_sample_rx;

    -------------------------------------------------------------------------------
    --*************************** TRANSMIT ****************************************
    -- This is the finit state machine for the transmit shift register
    -------------------------------------------------------------------------------

    txd_o <= s_txdm0;

    p_transmit : PROCESS (clk, reset)

        VARIABLE v_txstep : STD_LOGIC_VECTOR(1 DOWNTO 0);

    BEGIN

        IF reset = '1' THEN
            s_tran_state <= conv_unsigned(0, 4);
            s_tran_sh    <= conv_unsigned(0, 11);
            s_tran_done  <= '0';

            s_txdm0 <= '1';
            rxd_o   <= '1';
            rxdwr_o <= '0';
        ELSE
            IF clk'event AND clk = '1' THEN

                -- Set default behavior
                v_txstep := "00";

                CASE s_mode IS
                        -------------------------------------------------------------------------------
                        -- MODE 0
                        -------------------------------------------------------------------------------
                    WHEN ("00") =>

                        IF s_tran_state = conv_unsigned(1, 4) OR
                            s_tran_state = conv_unsigned(2, 4) OR
                            s_tran_state = conv_unsigned(3, 4) OR
                            s_tran_state = conv_unsigned(4, 4) OR
                            s_tran_state = conv_unsigned(5, 4) OR
                            s_tran_state = conv_unsigned(6, 4) OR
                            s_tran_state = conv_unsigned(7, 4) OR
                            s_tran_state = conv_unsigned(8, 4) OR
                            s_recv_state = conv_unsigned(1, 4) OR
                            s_recv_state = conv_unsigned(2, 4) OR
                            s_recv_state = conv_unsigned(3, 4) OR
                            s_recv_state = conv_unsigned(4, 4) OR
                            s_recv_state = conv_unsigned(5, 4) OR
                            s_recv_state = conv_unsigned(6, 4) OR
                            s_recv_state = conv_unsigned(7, 4) OR
                            s_recv_state = conv_unsigned(8, 4) THEN
                            IF s_txpre_count(3 DOWNTO 0) = conv_unsigned(14, 4) OR
                                s_txpre_count(3 DOWNTO 0) = conv_unsigned(6, 4) THEN
                                s_txdm0 <= NOT(s_txdm0);
                            END IF;
                        ELSE
                            s_txdm0 <= '1';
                        END IF;

                        IF s_m0_shift_en = '1' THEN
                            CASE s_tran_state IS
                                WHEN ("0001") => -- D1
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    rxd_o   <= s_tran_sh(1);
                                    rxdwr_o <= '1';
                                WHEN ("0010") => -- D2
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    rxd_o   <= s_tran_sh(1);
                                    rxdwr_o <= '1';
                                WHEN ("0011") => -- D3
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    rxd_o   <= s_tran_sh(1);
                                    rxdwr_o <= '1';
                                WHEN ("0100") => -- D4
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    rxd_o   <= s_tran_sh(1);
                                    rxdwr_o <= '1';
                                WHEN ("0101") => -- D5
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    rxd_o   <= s_tran_sh(1);
                                    rxdwr_o <= '1';
                                WHEN ("0110") => -- D6
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    rxd_o   <= s_tran_sh(1);
                                    rxdwr_o <= '1';
                                WHEN ("0111") => -- D7
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    rxd_o   <= s_tran_sh(1);
                                    rxdwr_o <= '1';
                                WHEN ("1000") => -- D8, STOP BIT
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    s_tran_done           <= '1';
                                    v_txstep := "10";
                                    rxd_o   <= s_tran_sh(1);
                                    rxdwr_o <= '1';
                                WHEN OTHERS => -- D0
                                    -- commence transmission if conditions are met
                                    rxdwr_o <= '0';
                                    IF s_trans = '1' THEN
                                        s_tran_sh(10 DOWNTO 8) <= conv_unsigned(7, 3);
                                        s_tran_sh(7 DOWNTO 0)  <= unsigned(sbuf_i);
                                        v_txstep := "01";
                                        s_tran_done <= '0';
                                        rxd_o       <= sbuf_i(0);
                                        rxdwr_o     <= '1';
                                    END IF;
                            END CASE;
                        END IF;
                        -------------------------------------------------------------------------------
                        -- MODE 1
                        -------------------------------------------------------------------------------
                    WHEN ("01") =>
                        rxdwr_o <= '0';
                        rxd_o   <= '0';
                        CASE s_tran_state IS
                            WHEN ("0001") => -- D1
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0010") => -- D2
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0011") => -- D3
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0100") => -- D4
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0101") => -- D5
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0110") => -- D6
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0111") => -- D7
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("1000") => -- D8
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("1001") => -- D9, set done bit
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    s_tran_done           <= '1';
                                    v_txstep := "10";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN OTHERS => -- D0
                                -- commence transmission if conditions are met
                                s_txdm0 <= '1';
                                IF s_m13_txshift_en = '1' THEN
                                    IF s_trans = '1' THEN
                                        s_tran_sh(10 DOWNTO 9) <= conv_unsigned(3, 2);
                                        s_tran_sh(8 DOWNTO 1)  <= unsigned(sbuf_i);
                                        s_tran_sh(0)           <= '0';
                                        v_txstep := "01";
                                        s_tran_done <= '0';
                                        s_txdm0     <= '0';
                                    END IF;
                                END IF;
                        END CASE;
                        -------------------------------------------------------------------------------
                        -- MODE 2
                        -------------------------------------------------------------------------------
                    WHEN ("10") =>
                        rxdwr_o <= '0';
                        rxd_o   <= '0';
                        CASE s_tran_state IS
                            WHEN ("0001") => -- D1
                                IF s_m2_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0010") => -- D2
                                IF s_m2_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0011") => -- D3
                                IF s_m2_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0100") => -- D4
                                IF s_m2_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0101") => -- D5
                                IF s_m2_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0110") => -- D6
                                IF s_m2_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0111") => -- D7
                                IF s_m2_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("1000") => -- D8
                                IF s_m2_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("1001") => -- D9
                                IF s_m2_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("1010") => -- D10, set done bit
                                IF s_m2_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    s_tran_done           <= '1';
                                    v_txstep := "10";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN OTHERS => -- D0
                                -- commence transmission if conditions are met
                                s_txdm0 <= '1';
                                IF s_m2_txshift_en = '1' THEN
                                    IF s_trans = '1' THEN
                                        s_tran_sh(10)         <= '1';
                                        s_tran_sh(9)          <= s_tb8;
                                        s_tran_sh(8 DOWNTO 1) <= unsigned(sbuf_i);
                                        s_tran_sh(0)          <= '0';
                                        v_txstep := "01";
                                        s_tran_done <= '0';
                                        s_txdm0     <= '0';
                                    END IF;
                                END IF;
                        END CASE;
                        -------------------------------------------------------------------------------
                        -- MODE 3
                        -------------------------------------------------------------------------------
                    WHEN ("11") =>
                        rxd_o   <= '0';
                        rxdwr_o <= '0';
                        CASE s_tran_state IS
                            WHEN ("0001") => -- D1
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0010") => -- D2
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0011") => -- D3
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0100") => -- D4
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0101") => -- D5
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0110") => -- D6
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("0111") => -- D7
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("1000") => -- D8
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("1001") => -- D9
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    v_txstep := "01";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN ("1010") => -- D10, set done bit
                                IF s_m13_txshift_en = '1' THEN
                                    s_tran_sh(10)         <= '1';
                                    s_tran_sh(9 DOWNTO 0) <= s_tran_sh(10 DOWNTO 1);
                                    s_tran_done           <= '1';
                                    v_txstep := "10";
                                    s_txdm0 <= s_tran_sh(1);
                                END IF;
                            WHEN OTHERS => -- D0
                                -- commence transmission if conditions are met
                                s_txdm0 <= '1';
                                IF s_m13_txshift_en = '1' THEN
                                    IF s_trans = '1' THEN
                                        s_tran_sh(10)         <= '1';
                                        s_tran_sh(9)          <= s_tb8;
                                        s_tran_sh(8 DOWNTO 1) <= unsigned(sbuf_i);
                                        s_tran_sh(0)          <= '0';
                                        s_tran_done           <= '0';
                                        v_txstep := "01";
                                        s_txdm0 <= '0';
                                    END IF;
                                END IF;
                        END CASE;
                        -------------------------------------------------------------------------------
                    WHEN OTHERS =>
                        NULL;
                END CASE;

                CASE v_txstep IS
                    WHEN "01" =>
                        s_tran_state <= s_tran_state + conv_unsigned(1, 1);
                    WHEN "10" =>
                        s_tran_state <= conv_unsigned(0, 4);
                    WHEN OTHERS =>
                        NULL;
                END CASE;

            END IF;
        END IF;
    END PROCESS p_transmit;

    -------------------------------------------------------------------------------
    --**************************** RECEIVE ****************************************
    -- This is the finit state machine for the receive shift register
    -------------------------------------------------------------------------------

    p_receive : PROCESS (clk, reset)

        VARIABLE v_rxstep : STD_LOGIC_VECTOR(1 DOWNTO 0);

    BEGIN

        IF reset = '1' THEN
            s_recv_state <= conv_unsigned(0, 4);
            s_recv_sh    <= conv_unsigned(0, 8);
            s_recv_buf   <= conv_unsigned(0, 8);
            s_recv_done  <= '0';
            s_rb8        <= '0';
        ELSE
            IF clk'event AND clk = '1' THEN

                -------------------------------------------------------------------------------
                -- MODE 0
                -------------------------------------------------------------------------------
                v_rxstep := "00";
                CASE s_mode IS
                    WHEN ("00") =>
                        CASE s_recv_state IS
                            WHEN ("0000") => -- D0
                                -- commence reception if conditions are met
                                IF s_ren = '1' AND s_ri = '0' THEN
                                    IF s_m0_shift_en = '1' THEN
                                        v_rxstep := "01";
                                        s_recv_done <= '0';
                                    END IF;
                                END IF;
                            WHEN ("0001") => -- D1
                                IF s_m0_shift_en = '1' THEN
                                    s_recv_sh(7)          <= rxd_i;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0010") => -- D2
                                IF s_m0_shift_en = '1' THEN
                                    s_recv_sh(7)          <= rxd_i;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0011") => -- D3
                                IF s_m0_shift_en = '1' THEN
                                    s_recv_sh(7)          <= rxd_i;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0100") => -- D4
                                IF s_m0_shift_en = '1' THEN
                                    s_recv_sh(7)          <= rxd_i;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0101") => -- D5
                                IF s_m0_shift_en = '1' THEN
                                    s_recv_sh(7)          <= rxd_i;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0110") => -- D6
                                IF s_m0_shift_en = '1' THEN
                                    s_recv_sh(7)          <= rxd_i;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0111") => -- D6
                                IF s_m0_shift_en = '1' THEN
                                    s_recv_sh(7)          <= rxd_i;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1000") => -- D7, set bits and store data
                                IF s_m0_shift_en = '1' THEN
                                    s_recv_sh(7)           <= rxd_i;
                                    s_recv_sh(6 DOWNTO 0)  <= s_recv_sh(7 DOWNTO 1);
                                    s_recv_done            <= '1';
                                    s_recv_buf(7)          <= rxd_i;
                                    s_recv_buf(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "10";
                                END IF;
                            WHEN OTHERS =>
                                v_rxstep := "10";
                        END CASE;

                        -------------------------------------------------------------------------------
                        -- MODE 1
                        -------------------------------------------------------------------------------
                    WHEN ("01") =>
                        CASE s_recv_state IS
                            WHEN ("0000") => -- synchronise reception
                                IF s_ren = '1' AND s_detect = '1' THEN
                                    v_rxstep := "01";
                                    s_recv_sh   <= conv_unsigned(0, 8);
                                    s_recv_done <= '0';
                                END IF;
                            WHEN ("0001") => -- D0 = START BIT
                                IF s_detect = '0' THEN
                                    IF s_rxd_val = '0' THEN
                                        IF s_m13_rxshift_en = '1' THEN
                                            s_recv_sh(7)          <= s_rxd_val;
                                            s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                            v_rxstep := "01";
                                        END IF;
                                    ELSE -- reject false start bits
                                        IF s_m13_rxshift_en = '1' THEN
                                            v_rxstep := "10";
                                        END IF;
                                    END IF;
                                END IF;
                            WHEN ("0010") => -- D1
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0011") => -- D2
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0100") => -- D3
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0101") => -- D4
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0110") => -- D5
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0111") => -- D6
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1000") => -- D7
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1001") => -- D8
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1010") => -- D9 = STOP BIT
                                -- store data and set interrupt bit if conditions are met.
                                IF (s_ri = '0' AND s_sm2 = '0') OR
                                    (s_ri = '0' AND s_rxd_val = '1') THEN
                                    --if s_m13_rxshift_en = '1' then
                                    IF s_rxpre_count(3 DOWNTO 0) = conv_unsigned(10, 4) THEN -- CK, CV: changed to enter state 0 after one stopbit
                                        s_recv_sh(7)          <= s_rxd_val;
                                        s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                        v_rxstep := "10";
                                        s_recv_done <= '1';
                                        s_rb8       <= s_rxd_val;
                                        s_recv_buf  <= s_recv_sh(7 DOWNTO 0);
                                    END IF;
                                    -- forget data and recommence listening for a start bit
                                ELSE
                                    IF s_m13_rxshift_en = '1' THEN
                                        v_rxstep := "10";
                                    END IF;
                                END IF;
                            WHEN OTHERS =>
                                v_rxstep := "10";
                        END CASE;

                        -------------------------------------------------------------------------------
                        -- MODE 2
                        -------------------------------------------------------------------------------
                    WHEN ("10") =>
                        CASE s_recv_state IS
                            WHEN ("0000") => -- synchronise reception
                                IF s_ren = '1' AND s_detect = '1' THEN
                                    v_rxstep := "01";
                                    s_recv_sh   <= conv_unsigned(0, 8);
                                    s_recv_done <= '0';
                                END IF;
                            WHEN ("0001") => -- D0 = START BIT
                                IF s_rxd_val = '0' THEN
                                    IF s_m2_rxshift_en = '1' THEN
                                        s_recv_sh(7)          <= s_rxd_val;
                                        s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                        v_rxstep := "01";
                                    END IF;
                                ELSE -- reject false start bits
                                    IF s_m2_rxshift_en = '1' THEN
                                        v_rxstep := "10";
                                    END IF;
                                END IF;
                            WHEN ("0010") => -- D1
                                IF s_m2_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0011") => -- D2
                                IF s_m2_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0100") => -- D3
                                IF s_m2_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0101") => -- D4
                                IF s_m2_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0110") => -- D5
                                IF s_m2_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0111") => -- D6
                                IF s_m2_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1000") => -- D7
                                IF s_m2_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1001") => -- D8
                                IF s_m2_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1010") => -- D9
                                -- store data and set interrupt bit if conditions are met.
                                IF (s_ri = '0' AND s_sm2 = '0') OR
                                    (s_ri = '0' AND s_rxd_val = '1') THEN
                                    IF s_m2_rxshift_en = '1' THEN
                                        s_recv_sh(7)          <= s_rxd_val;
                                        s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                        s_recv_done           <= '1';
                                        s_rb8                 <= s_rxd_val;
                                        s_recv_buf            <= s_recv_sh(7 DOWNTO 0);
                                    END IF;
                                END IF;
                                -- forget data 
                                IF s_m2_rxshift_en = '1' THEN
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1011") => -- D10 STOP BIT
                                -- recommence listening for a start bit
                                IF s_m2_rxshift_en = '1' THEN
                                    -- s_recv_state <= conv_unsigned(0,4);
                                    v_rxstep := "10";
                                END IF;
                            WHEN OTHERS =>
                                -- s_recv_state <= conv_unsigned(0,4);
                                v_rxstep := "10";
                        END CASE;

                        -------------------------------------------------------------------------------
                        -- MODE 3
                        -------------------------------------------------------------------------------
                    WHEN ("11") =>
                        CASE s_recv_state IS
                            WHEN ("0000") => -- synchronise reception
                                IF s_ren = '1' AND s_detect = '1' THEN
                                    v_rxstep := "01";
                                    s_recv_sh   <= conv_unsigned(0, 8);
                                    s_recv_done <= '0';
                                END IF;
                            WHEN ("0001") => -- D0 = START BIT
                                IF s_detect = '0' THEN
                                    IF s_rxd_val = '0' THEN
                                        IF s_m13_rxshift_en = '1' THEN
                                            s_recv_sh(7)          <= s_rxd_val;
                                            s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                            v_rxstep := "01";
                                        END IF;
                                    ELSE -- reject false start bits
                                        IF s_m13_rxshift_en = '1' THEN
                                            v_rxstep := "10";
                                        END IF;
                                    END IF;
                                END IF;
                            WHEN ("0010") => -- D1
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0011") => -- D2
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0100") => -- D3
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0101") => -- D4
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0110") => -- D5
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("0111") => -- D6
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1000") => -- D7
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1001") => -- D8
                                IF s_m13_rxshift_en = '1' THEN
                                    s_recv_sh(7)          <= s_rxd_val;
                                    s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1010") => -- D9
                                -- store data and set interrupt bit if conditions are met.
                                IF (s_ri = '0' AND s_sm2 = '0') OR
                                    (s_ri = '0' AND s_rxd_val = '1') THEN
                                    IF s_m13_rxshift_en = '1' THEN
                                        s_recv_sh(7)          <= s_rxd_val;
                                        s_recv_sh(6 DOWNTO 0) <= s_recv_sh(7 DOWNTO 1);
                                        s_recv_done           <= '1';
                                        s_rb8                 <= s_rxd_val;
                                        s_recv_buf            <= s_recv_sh(7 DOWNTO 0);
                                    END IF;
                                END IF;
                                -- forget data 
                                IF s_m13_rxshift_en = '1' THEN
                                    v_rxstep := "01";
                                END IF;
                            WHEN ("1011") => -- D10 STOP BIT
                                -- recommence listening for a start bit
                                IF s_m13_rxshift_en = '1' THEN
                                    v_rxstep := "10";
                                END IF;
                            WHEN OTHERS =>
                                v_rxstep := "10";
                        END CASE;
                    WHEN OTHERS =>
                        NULL;
                END CASE;

                CASE v_rxstep IS
                    WHEN "01" =>
                        s_recv_state <= s_recv_state + conv_unsigned(1, 1);
                    WHEN "10" =>
                        s_recv_state <= conv_unsigned(0, 4);
                    WHEN OTHERS =>
                        NULL;
                END CASE;

            END IF;
        END IF;

    END PROCESS p_receive;

END rtl;