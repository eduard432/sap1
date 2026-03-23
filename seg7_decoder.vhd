library ieee;
use ieee.std_logic_1164.all;

entity seg7_decoder is
	port(
		 data : in std_logic_vector(3 downto 0);
		 seg  : out std_logic_vector(6 downto 0) -- a b c d e f g
	);
end entity seg7_decoder;

architecture bh of seg7_decoder is
	signal seg_tmp: std_logic_vector(6 downto 0);

begin

	process(data)
	begin

	case data is
		 when "0000" => seg_tmp <= "1111110"; --0
		 when "0001" => seg_tmp <= "0110000"; --1
		 when "0010" => seg_tmp <= "1101101"; --2
		 when "0011" => seg_tmp <= "1111001"; --3
		 when "0100" => seg_tmp <= "0110011"; --4
		 when "0101" => seg_tmp <= "1011011"; --5
		 when "0110" => seg_tmp <= "1011111"; --6
		 when "0111" => seg_tmp <= "1110000"; --7
		 when "1000" => seg_tmp <= "1111111"; --8
		 when "1001" => seg_tmp <= "1111011"; --9
		 when others => seg_tmp <= "0000000";
	end case;

	end process;
	
	seg <= not (seg_tmp(0) & seg_tmp(1) & seg_tmp(2) & seg_tmp(3) &
          seg_tmp(4) & seg_tmp(5) & seg_tmp(6));

end architecture bh;