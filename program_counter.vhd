library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity program_counter is
    generic (
        bits: integer := 4
    );
    port (
        clk: in std_logic;
        reset: in std_logic;
        CE: in std_logic; -- Counter enable
        CO: in std_logic; -- Counter out
        load: in std_logic;
        data_in: in std_logic_vector(bits - 1 downto 0);
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
            elsif load = '1' then
                cnt_temp <= data_in;
            elsif CE = '1' then
                cnt_temp <= cnt_temp + 1;
            end if;
        end if;
    end process;

    counter <= cnt_temp when CO = '1' else (others => '0');
end architecture bh;