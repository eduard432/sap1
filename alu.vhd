library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    generic (
        bits := 8
    );
    port (
        A, B    : in  std_logic_vector(bits - 1 downto 0);
        op      : in  std_logic; -- 0 = suma, 1 = resta
        result  : out std_logic_vector(bits - 1 downto 0);
        carry   : out std_logic
    );
end entity alu;

architecture bh of alu is
begin
    process(A, B, op)
        variable temp : unsigned(bits downto 0);
        variable a_u, b_u : unsigned(bits - 1 downto 0);
    begin
        a_u := unsigned(A);
        b_u := unsigned(B);

        if op = '0' then
            -- SUMA
            temp := ('0' & a_u) + ('0' & b_u);
        else
            -- RESTA (A - B)
            temp := ('0' & a_u) - ('0' & b_u);
        end if;

        result <= std_logic_vector(temp(bits - 1 downto 0));
        carry  <= temp(bits);
    end process;
end architecture;