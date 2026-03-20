library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin2bcd is
    port(
        bin  : in  std_logic_vector(6 downto 0);
        bcd2 : out std_logic_vector(3 downto 0); -- centenas
        bcd1 : out std_logic_vector(3 downto 0); -- decenas
        bcd0 : out std_logic_vector(3 downto 0)  -- unidades
    );
end entity bin2bcd;

architecture bh of bin2bcd is
begin

process(bin)

    variable value : integer range 0 to 127;
    variable hundreds : integer range 0 to 1;
    variable tens : integer range 0 to 9;
    variable ones : integer range 0 to 9;

begin

    value := to_integer(unsigned(bin));

    -- Centenas
    if value >= 100 then
        hundreds := 1;
        value := value - 100;
    else
        hundreds := 0;
    end if;

    -- Decenas
    if value >= 90 then tens := 9; value := value - 90;
    elsif value >= 80 then tens := 8; value := value - 80;
    elsif value >= 70 then tens := 7; value := value - 70;
    elsif value >= 60 then tens := 6; value := value - 60;
    elsif value >= 50 then tens := 5; value := value - 50;
    elsif value >= 40 then tens := 4; value := value - 40;
    elsif value >= 30 then tens := 3; value := value - 30;
    elsif value >= 20 then tens := 2; value := value - 20;
    elsif value >= 10 then tens := 1; value := value - 10;
    else tens := 0;
    end if;

    -- Unidades
    ones := value;

    bcd2 <= std_logic_vector(to_unsigned(hundreds,4));
    bcd1 <= std_logic_vector(to_unsigned(tens,4));
    bcd0 <= std_logic_vector(to_unsigned(ones,4));

end process;

end architecture;