library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity rbbs is
    port(
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

end rbbs;

architecture behavior of rbbs is
    signal clk: std_logic := '0';
    signal priority: std_logic_vector(1 downto 0);
    signal priority_reg: std_logic_vector(1 downto 0);
    signal priority_plus_one: std_logic_vector(1 downto 0);

    signal mux_out: std_logic;
    signal not_mux_out: std_logic;

    signal served: std_logic_vector(3 downto 0);
    signal served_reg: std_logic_vector(3 downto 0);

    signal served_ord_0, served_ord_1, served_ord_2, served_ord_3: std_logic;
    signal served_desord_0, served_desord_1, served_desord_2, served_desord_3: std_logic;

    signal req_ord_0, req_ord_1, req_ord_2, req_ord_3: std_logic;

begin
    clock: process
    begin
        wait for 10 ns;
        clk <= not clk;
    end process;

    -- requests enters

    -- requests priority ordenation top down
    with priority select req_ord_0 <=
        request_0 when "00",
        request_1 when "01",
        request_2 when "10",
        request_3 when "11",
        'X'  when others;

    with priority select req_ord_1 <=
        request_1 when "00",
        request_2 when "01",
        request_3 when "10",
        request_0 when "11",
        'X'  when others;

    with priority select req_ord_2 <=
        request_2 when "00",
        request_3 when "01",
        request_0 when "10",
        request_1 when "11",
        'X'  when others;

    with priority select req_ord_3 <=
        request_3 when "00",
        request_0 when "01",
        request_1 when "10",
        request_2 when "11",
        'X'  when others;

    -- requests priority accordance. Tell what request is being served
    served_ord_0 <=     req_ord_0;
    served_ord_1 <= not req_ord_0 and     req_ord_1;
    served_ord_2 <= not req_ord_0 and not req_ord_1 and     req_ord_2;
    served_ord_3 <= not req_ord_0 and not req_ord_1 and not req_ord_2 and req_ord_3;

    -- served desordenation
    with priority select served_desord_0 <=
        served_ord_0 when "00",
        served_ord_3 when "01",
        served_ord_2 when "10",
        served_ord_1 when "11",
        'X'  when others;

    with priority select served_desord_1 <=
        served_ord_1 when "00",
        served_ord_0 when "01",
        served_ord_3 when "10",
        served_ord_2 when "11",
        'X'  when others;

    with priority select served_desord_2 <= 
        served_ord_2 when "00",
        served_ord_1 when "01",
        served_ord_0 when "10",
        served_ord_3 when "11",
        'X'  when others;

    with priority select served_desord_3 <=
        served_ord_3 when "00",
        served_ord_2 when "01",
        served_ord_1 when "10",
        served_ord_0 when "11",
        'X'  when others;

    served <= served_desord_0 & served_desord_1 & served_desord_2 & served_desord_3;

    -- priority and served write process
    registers: process (clk, rst, not_mux_out)

    begin
        if (rst = '1') then
            priority_reg <= "00";
            served_reg <= "0000";

        elsif (clk'event and not_mux_out = '1') then
            if (served_reg = "0000") then
                served_reg <= served;
            
            else
                priority_reg <= priority_plus_one;
                served_reg <= served;

            end if;

        end if;

    end process registers;

    with served_reg select mux_out <=
        '0'             when "0000",
        served_desord_0 when "1000",
        served_desord_1 when "0100",
        served_desord_2 when "0010",
        served_desord_3 when "0001",
        'X'             when others;

    not_mux_out <= not mux_out;
    
    priority <= priority_reg;
    priority_plus_one <= priority + 1;
    
    -- Bridge selection
    -- sharer to requisitor data
    with served_reg select requisitor_in_0 <=
        sharer_out      when "1000",
        (others => '0') when others;

    with served_reg select requisitor_in_1 <=
        sharer_out      when "0100",
        (others => '0') when others;

    with served_reg select requisitor_in_2 <=
        sharer_out      when "0010",
        (others => '0') when others;

    with served_reg select requisitor_in_3 <=
        sharer_out      when "0001",
        (others => '0') when others;

    -- requisitor to sharer data
    with served_reg select sharer_in <=
        requisitor_out_0 when "1000",
        requisitor_out_1 when "0100",
        requisitor_out_2 when "0010",
        requisitor_out_3 when "0001",
        (others => '0')  when others;

    -- requested signals
    requested_0 <= served_reg(3);
    requested_1 <= served_reg(2);
    requested_2 <= served_reg(1);
    requested_3 <= served_reg(0);

end behavior;
