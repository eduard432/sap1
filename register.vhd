library ieee;
use ieee.std_logic_1164.all;

entity register is
    generic (
        bits: integer := 8
    );
    port (
        clk   : in std_logic;
        clear : in std_logic;
        WE    : in std_logic;
        OE    : in std_logic;
        I     : in std_logic_vector(bits - 1 downto 0);
        Q     : out std_logic_vector(bits - 1 downto 0)
    );
end entity;

architecture bh of register is
    signal Q_temp: std_logic_vector(bits - 1 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if clear = '1' then
                Q_temp <= (others => '0');
            elsif WE = '1' then
                Q_temp <= I;
            end if;
        end if;
    end process;

    Q <= Q_temp when OE = '1' else (others => '0');

end architecture;