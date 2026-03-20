library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port (
        clk      : in  std_logic;
        we       : in  std_logic;
        addr     : in  std_logic_vector(7 downto 0);
        data_in  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity;

architecture bh of ram is
    type ram_type is array (0 to 255) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                RAM(to_integer(unsigned(addr))) <= data_in;
            end if;

            data_out <= RAM(to_integer(unsigned(addr)));
        end if;
    end process;

end architecture;