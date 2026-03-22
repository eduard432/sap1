library ieee;
use ieee.std_logic_1164.all;

entity output is
    port (
        bin: in std_logic(7 downto 0);
        OI: in std_logic;
        bcd0, bcd1, bcd2: out std_logic_vector(3 downto 0)
    );
end entity output;

architecture bh of output is

    component bin2bcd is
        port(
            bin  : in  std_logic_vector(7 downto 0);
            bcd2 : out std_logic_vector(3 downto 0); -- centenas
            bcd1 : out std_logic_vector(3 downto 0); -- decenas
            bcd0 : out std_logic_vector(3 downto 0)  -- unidades
        );
    end component bin2bcd;


    signal bin_tmp: std_logic_vector(7 downto 0);
begin

    bin_tmp <= bin when OI = '1' else (others => '0');

    CONVERTER: bin2bcd
    port map (
        bin => bin_tmp,
        bcd2 => bcd2,
        bcd1 => bcd1,
        bcd0 => bcd0
    );

end architecture bh;