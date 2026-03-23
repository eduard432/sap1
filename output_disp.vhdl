library ieee;
use ieee.std_logic_1164.all;

entity output_disp is
    port (
        bin: in std_logic_vector(7 downto 0);
        OI: in std_logic;
        seg0, seg1, seg2: out std_logic_vector(6 downto 0)
    );
end entity output_disp;

architecture bh of output_disp is

    component bin2bcd is
        port(
            bin  : in  std_logic_vector(7 downto 0);
            bcd2 : out std_logic_vector(3 downto 0); -- centenas
            bcd1 : out std_logic_vector(3 downto 0); -- decenas
            bcd0 : out std_logic_vector(3 downto 0)  -- unidades
        );
    end component bin2bcd;

    component seg7_decoder is
        port(
            data : in std_logic_vector(3 downto 0);
            seg  : out std_logic_vector(6 downto 0) -- a b c d e f g
        );
    end component seg7_decoder;

    signal bcd2_tmp, bcd1_tmp, bcd0_tmp: std_logic_vector(3 downto 0);
	 
	 signal bin_tmp: std_logic_vector(7 downto 0);
begin

    bin_tmp <= bin when OI = '1' else (others => '0');

    CONVERTER: bin2bcd
    port map (
        bin => bin_tmp,
        bcd2 => bcd2_tmp,
        bcd1 => bcd1_tmp,
        bcd0 => bcd0_tmp
    );

    S2: seg7_decoder
    port map(
        data => bcd2_tmp,
        seg => seg2
    );

    S1: seg7_decoder
    port map(
        data => bcd1_tmp,
        seg => seg1
    );

    S0: seg7_decoder
    port map(
        data => bcd0_tmp,
        seg => seg0
    );

end architecture bh;