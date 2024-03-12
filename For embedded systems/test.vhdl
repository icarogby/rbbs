library ieee;
use ieee.std_logic_1164.all;

entity test is end test;

architecture bhv of test is
    signal rst: std_logic;

    signal request_0: std_logic;
    signal request_1: std_logic;
    signal request_2: std_logic;
    signal request_3: std_logic;

    signal requested_0: std_logic;
    signal requested_1: std_logic;
    signal requested_2: std_logic;
    signal requested_3: std_logic;
    
    signal requisitor_in_0: std_logic_vector(3 downto 0);
    signal requisitor_in_1: std_logic_vector(3 downto 0);
    signal requisitor_in_2: std_logic_vector(3 downto 0);
    signal requisitor_in_3: std_logic_vector(3 downto 0);

    signal requisitor_out_0: std_logic_vector(3 downto 0);
    signal requisitor_out_1: std_logic_vector(3 downto 0);
    signal requisitor_out_2: std_logic_vector(3 downto 0);
    signal requisitor_out_3: std_logic_vector(3 downto 0);

    signal sharer_in: std_logic_vector(3 downto 0);
    signal sharer_out: std_logic_vector(3 downto 0);

    component rbbs is
        port (
            rst: in std_logic;

            request_0: in std_logic;
            request_1: in std_logic;
            request_2: in std_logic;
            request_3: in std_logic;

            requested_0: out std_logic;
            requested_1: out std_logic;
            requested_2: out std_logic;
            requested_3: out std_logic;

            requisitor_in_0: out std_logic_vector(3 downto 0);
            requisitor_in_1: out std_logic_vector(3 downto 0);
            requisitor_in_2: out std_logic_vector(3 downto 0);
            requisitor_in_3: out std_logic_vector(3 downto 0);

            requisitor_out_0: in std_logic_vector(3 downto 0);
            requisitor_out_1: in std_logic_vector(3 downto 0);
            requisitor_out_2: in std_logic_vector(3 downto 0);
            requisitor_out_3: in std_logic_vector(3 downto 0);

            sharer_in: out std_logic_vector(3 downto 0);
            sharer_out: in std_logic_vector(3 downto 0)
            
        );

    end component;

begin
    dut: rbbs
        port map (
            rst => rst,

            request_0 => request_0,
            request_1 => request_1,
            request_2 => request_2,
            request_3 => request_3,

            requested_0 => requested_0,
            requested_1 => requested_1,
            requested_2 => requested_2,
            requested_3 => requested_3,

            requisitor_in_0 => requisitor_in_0,
            requisitor_in_1 => requisitor_in_1,
            requisitor_in_2 => requisitor_in_2,
            requisitor_in_3 => requisitor_in_3,

            requisitor_out_0 => requisitor_out_0,
            requisitor_out_1 => requisitor_out_1,
            requisitor_out_2 => requisitor_out_2,
            requisitor_out_3 => requisitor_out_3,

            sharer_in => sharer_in,
            sharer_out => sharer_out
        );
    
        
    test_process: process

    begin
        requisitor_out_0 <= "0000";
        requisitor_out_1 <= "0000";
        requisitor_out_2 <= "0000";
        requisitor_out_3 <= "0000";

        sharer_out <= "0000";

        request_0 <= '0';
        request_1 <= '0';
        request_2 <= '0';
        request_3 <= '0';

        wait for 10 ns;
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        requisitor_out_0 <= "1001";
        requisitor_out_1 <= "1010";
        requisitor_out_2 <= "1011";
        requisitor_out_3 <= "1100";

        sharer_out <= "1101";

        wait for 10 ns;

        request_0 <= '1';
        request_1 <= '1';
        request_2 <= '1';
        request_3 <= '1';

        wait for 10 ns;

        request_0 <= '0';

        wait for 10 ns;

        request_1 <= '0';

        wait for 10 ns;

        request_2 <= '0';

        wait for 10 ns;

        request_3 <= '0';

        wait for 10 ns;

        request_2 <= '1';
        request_3 <= '1';

        wait for 10 ns;

        request_2 <= '0';

        wait for 10 ns;

    end process;
    
end bhv;