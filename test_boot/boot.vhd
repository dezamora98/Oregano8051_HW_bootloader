

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

ENTITY boot IS
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
END boot;

ARCHITECTURE arch OF boot IS

    COMPONENT EdgeDetector IS
        PORT (
            Clock          : IN  STD_LOGIC;
            Reset          : IN  STD_LOGIC;
            SignalDetect   : IN  STD_LOGIC;
            RisingEdgeDet  : OUT STD_LOGIC;
            FallingEdgeDet : OUT STD_LOGIC
        );
    END COMPONENT;

    TYPE state_type IS (st_idle, st_wait_command, st_write, st_read, st_wait_size,
        st_wait_addr_h, st_wait_addr_l, st_wait_code, st_wait_data, st_write_data,
        st_send_data, st_wait_send_data, st_send_checksum);

    SIGNAL state, next_state : state_type := st_idle;

    SIGNAL size     : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
    SIGNAL new_size : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";

    SIGNAL code     : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
    SIGNAL new_code : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";

    SIGNAL addr     : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";
    SIGNAL new_addr : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";

    SIGNAL checksum     : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
    SIGNAL new_checksum : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";

    SIGNAL command     : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
    SIGNAL new_command : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
    CONSTANT CMD_READ  : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
    CONSTANT CMD_WRITE : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"01";

    SIGNAL data_in_ok  : STD_LOGIC;
    SIGNAL data_out_ok : STD_LOGIC;

BEGIN

    port_data_out <= mem_data_in WHEN state = st_send_data ELSE
                     checksum WHEN state = st_send_checksum ELSE
                     x"00";

    port_wr_data_out <= '1' WHEN state = st_send_data ELSE
                        '0';

    mem_addr <= addr;

    mem_data_out <= port_data_in;

    mem_ena <= '1' WHEN state = st_send_data OR state = st_write_data ELSE
               '0';
    mem_wea <= '1' WHEN state = st_write_data ELSE
               '0';

    i_parallel_in_ok : EdgeDetector
    PORT MAP(
        Clock         => clock,
        Reset         => reset,
        SignalDetect  => port_en_data_in,
        RisingEdgeDet => data_in_ok
    );

    i_parallel_out_ok : EdgeDetector
    PORT MAP(
        Clock         => clock,
        Reset         => reset,
        SignalDetect  => port_en_data_out,
        RisingEdgeDet => data_out_ok
    );

    sync : PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            state    <= st_idle;
            addr     <= x"0000";
            size     <= x"00";
            code     <= x"00";
            command  <= x"00";
            checksum <= x"00";
        ELSIF (clock'event AND clock = '1') THEN
            state    <= next_state;
            addr     <= new_addr;
            size     <= new_size;
            code     <= new_code;
            command  <= new_command;
            checksum <= new_checksum;
        END IF;
    END PROCESS; -- sync

    next_state_decode : PROCESS (state, en_boot, port_data_in, data_in_ok, data_out_ok,
        size, addr, code, command, checksum)
    BEGIN

        next_state   <= state;
        new_addr     <= addr;
        new_size     <= size;
        new_code     <= code;
        new_command  <= command;
        new_checksum <= checksum;

        CASE(state) IS

            WHEN st_idle =>
            IF en_boot = '1' THEN
                next_state <= st_wait_command;
            ELSE
                new_addr     <= x"0000";
                new_size     <= x"00";
                new_code     <= x"00";
                new_command  <= x"00";
                new_checksum <= x"00";
            END IF;

            WHEN st_wait_command =>
            IF data_in_ok = '1' THEN
                new_command  <= port_data_in;
                next_state   <= st_wait_size;
                new_checksum <= std_logic_vector(unsigned(checksum) + unsigned(port_data_in));
            END IF;

            WHEN st_wait_size =>
            IF data_in_ok = '1' THEN
                new_size     <= port_data_in;
                next_state   <= st_wait_addr_h;
                new_checksum <= std_logic_vector(unsigned(checksum) + unsigned(port_data_in));
            END IF;

            WHEN st_wait_addr_h =>
            IF data_in_ok = '1' THEN
                new_addr(15 DOWNTO 8) <= port_data_in;
                next_state            <= st_wait_addr_l;
                new_checksum          <= std_logic_vector(unsigned(checksum) + unsigned(port_data_in));
            END IF;

            WHEN st_wait_addr_l =>
            IF data_in_ok = '1' THEN
                new_addr(7 DOWNTO 0) <= port_data_in;
                next_state           <= st_wait_code;
                new_checksum         <= std_logic_vector(unsigned(checksum) + unsigned(port_data_in));
            END IF;

            WHEN st_wait_code =>
            IF data_in_ok = '1' THEN
                new_code     <= port_data_in;
                new_checksum <= std_logic_vector(unsigned(checksum) + unsigned(port_data_in));

                IF command = CMD_READ THEN
                    next_state <= st_read;
                ELSIF command = CMD_WRITE THEN
                    next_state <= st_write;
                    --ELSIF command = other_command THEN
                ELSE
                    next_state <= st_idle;
                END IF;
            END IF;

            WHEN st_write =>
            IF code = x"00" THEN
                next_state <= st_wait_data;
                --ELSIF code = other_coder THEN
            ELSE
                next_state <= st_idle;
            END IF;

            WHEN st_wait_data =>
            IF size = x"00" THEN
                new_checksum <= std_logic_vector(unsigned((NOT checksum)) + 1); --The two's complement
                next_state   <= st_send_checksum;
            ELSIF data_in_ok = '1' THEN
                new_checksum <= std_logic_vector(unsigned(checksum) + unsigned(port_data_in));
                next_state   <= st_write_data;
            END IF;

            WHEN st_write_data =>
            new_addr   <= std_logic_vector(unsigned(addr) + 1);
            new_size   <= std_logic_vector(unsigned(size) - 1);
            next_state <= st_wait_data;

            

            WHEN st_send_checksum =>
            next_state <= st_idle;

            WHEN st_read =>
            IF code = x"01" THEN
                next_state <= st_send_data;
                --ELSIF code = other_coder THEN
            ELSE
                next_state <= st_idle;
            END IF;

            WHEN st_send_data =>
            next_state <= st_wait_send_data;

            WHEN st_wait_send_data =>
            IF data_out_ok = '1' THEN
                IF size = x"00" THEN
                    new_checksum <= std_logic_vector(unsigned((NOT checksum)) + 1); --The two's complement
                    next_state   <= st_send_checksum;
                ELSE
                    new_checksum <= std_logic_vector(unsigned(checksum) + unsigned(port_data_in));
                    new_addr     <= std_logic_vector(unsigned(addr) + 1);
                    new_size     <= std_logic_vector(unsigned(size) - 1);
                    next_state   <= st_send_data;
                END IF;
            END IF;
            WHEN OTHERS =>
            next_state <= st_idle;
        END CASE;

    END PROCESS; -- next_state_decode

END ARCHITECTURE; -- arch