library ieee;
use ieee.std_logic_1164.all;

entity program_counter is
    generic (
        bits: integer := 4;
    );
    port (
        clk: in std_logic;
        reset: in std_logic;
        counter: out std_logic_vector(bits - 1 downto 0)
    );
end entity;

architecture bh of program_counter is
    signal cnt_temp: std_logic_vector(bits - 1 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                cnt_temp <= (others => '0');
            else
                cnt_temp <= cnt_temp + 1;
            end if;
        end if;
    end process;
end architecture bh;