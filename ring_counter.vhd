library ieee;
use ieee.std_logic_1164.all;

entity ring_counter is
    generic (
        bits: integer := 4
    );
    port (
        clk: in std_logic;
        reset: in std_logic;
        Q: out std_logic_vector(bits - 1 downto 0)
    );
end entity;

architecture bh of ring_counter is
    signal q_temp: std_logic_vector(bits - 1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q_temp <= (0 => '1', others => '0');
        elsif rising_edge(clk) then
            q_temp <= q_temp(bits - 2 downto 0) & q_temp(bits - 1);
        end if;
    end process;

    Q <= q_temp;
end architecture;