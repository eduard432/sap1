library ieee;
use ieee.std_logic_1164.all;

entity clock is
    generic (
        pulse: integer := 10
    );
    port (
        clk: in std_logic;          -- board cloack
        manual_clk: in std_logic;   -- button clock
        sel: in std_logic;          -- select between two modes
        HLT: in std_logic;          -- Stop de computer
        clk_out: out std_logic      -- Clock output
    );
end entity clock;

architecture bh of clock is
    signal new_clock: std_logic := '0';
	 signal selected_clk: std_logic;
begin
    process(clk)
        variable count: integer := 0;
    begin
        if(rising_edge(clk)) then
            count := count + 1;
            if(count = pulse) then
                new_clock <= not new_clock;
                count := 0;
            end if;
        end if;
    end process;

	selected_clk <= new_clock when sel = '1' else manual_clk;

	clk_out <= selected_clk when HLT = '0' else '0';
	

end architecture bh;