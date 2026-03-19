library ieee;
use ieee.std_logic_1164.all;

entity sap1 is
    port (
        clk: in std_logic;          -- board cloack
        manual_clk: in std_logic;   -- button clock
        sel: in std_logic;          -- select between two modes
        HLT: in std_logic;          -- Stop de computer
        clk_out: out std_logic      -- Clock output
    );
end entity sap1;

architecture bh of sap1 is
    component clock is
        generic (
            pulse: integer := 25000000
        );
        port (
            clk: in std_logic;          -- board cloack
            manual_clk: in std_logic;   -- button clock
            sel: in std_logic;          -- select between two modes
            HLT: in std_logic;          -- Stop de computer
            clk_out: out std_logic      -- Clock output
        );
    end component clock;
begin
    CL0: clock
    generic map(
        25000000        
    )
    port map (
        clk => clk,
        manual_clk => not manual_clk,
        sel => sel,
        HLT => HLT,
        clk_out => clk_out
    );
end architecture bh;