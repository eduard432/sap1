library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin2bcd is
    port(
        bin  : in  std_logic_vector(7 downto 0);
        bcd2 : out std_logic_vector(3 downto 0); -- centenas
        bcd1 : out std_logic_vector(3 downto 0); -- decenas
        bcd0 : out std_logic_vector(3 downto 0)  -- unidades
    );
end entity;

architecture bh of bin2bcd is
begin

process(bin)
    variable shift_reg : std_logic_vector(19 downto 0); 
    -- [19:16]=centenas, [15:12]=decenas, [11:8]=unidades, [7:0]=binario
    variable i : integer;
begin

    -- Inicializar
    shift_reg := (others => '0');
    shift_reg(7 downto 0) := bin;

    -- Double Dabble (8 iteraciones)
    for i in 0 to 7 loop
        
        -- Ajuste BCD (add 3 si >= 5)
        if unsigned(shift_reg(11 downto 8)) >= 5 then
            shift_reg(11 downto 8) := std_logic_vector(unsigned(shift_reg(11 downto 8)) + 3);
        end if;

        if unsigned(shift_reg(15 downto 12)) >= 5 then
            shift_reg(15 downto 12) := std_logic_vector(unsigned(shift_reg(15 downto 12)) + 3);
        end if;

        if unsigned(shift_reg(19 downto 16)) >= 5 then
            shift_reg(19 downto 16) := std_logic_vector(unsigned(shift_reg(19 downto 16)) + 3);
        end if;

        -- Shift a la izquierda
        shift_reg := shift_reg(18 downto 0) & '0';

    end loop;

    -- Salidas
    bcd2 <= shift_reg(19 downto 16);
    bcd1 <= shift_reg(15 downto 12);
    bcd0 <= shift_reg(11 downto 8);

end process;

end architecture;