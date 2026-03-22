library ieee;
use ieee.std_logic_1164.all;

entity sap1_tb is
end entity;

architecture tb of sap1_tb is

    signal clk: std_logic := '0';

    -- outputs
    signal bcd0, bcd1, bcd2: std_logic_vector(3 downto 0);

    -- control signals
	signal HALT: std_logic := '1';
    signal CO, J, CE: std_logic := '0';
    signal AI, AO: std_logic := '0';
    signal EO, SU: std_logic := '0';
    signal CY: std_logic;
    signal BI, BO: std_logic := '0';
    signal OI: std_logic := '0';
    signal MI: std_logic := '0';
    signal RI, RO: std_logic := '0';
    signal II, IO: std_logic := '0';

    signal RAM_PROGRAM_DATA: std_logic_vector(7 downto 0) := (others => '0');

begin

    -- clock 10 ns
    clk <= not clk after 5 ns;

    DUT: entity work.sap1
    port map (
        clk_in => clk,
        bcd0 => bcd0,
        bcd1 => bcd1,
        bcd2 => bcd2,
	HALT => HALT,
        RAM_PROGRAM_DATA => RAM_PROGRAM_DATA,
        CO => CO,
        J => J,
        CE => CE,
        AI => AI,
        AO => AO,
        EO => EO,
        SU => SU,
        CY => CY,
        BI => BI,
        BO => BO,
        OI => OI,
        MI => MI,
        RI => RI,
        RO => RO,
        II => II,
        IO => IO
    );

    process
    begin

        --------------------------------------------------
        -- ?? FASE 1: CARGAR RAM
        --------------------------------------------------

        -- Dirección 0
        CO <= '1';           -- PC ? bus (0)
        MI <= '1';           -- MAR <- bus
        wait for 10 ns;

        CO <= '0';
        MI <= '0';

        RAM_PROGRAM_DATA <= "00010001"; -- LDA 1
        RI <= '1';           -- escribir
        wait for 10 ns;
        RI <= '0';

        --------------------------------------------------
        -- Dirección 1
        --------------------------------------------------
        CE <= '1';           -- PC++
        wait for 10 ns;
        CE <= '0';

        CO <= '1';
        MI <= '1';
        wait for 10 ns;

        CO <= '0';
        MI <= '0';

        RAM_PROGRAM_DATA <= "11100000"; -- OUT
        RI <= '1';
        wait for 10 ns;
        RI <= '0';

        --------------------------------------------------
        -- ?? RESET señales
        --------------------------------------------------
        wait for 20 ns;

        --------------------------------------------------
        -- ?? FASE 2: FETCH
        --------------------------------------------------

        -- T0: PC -> BUS
        CO <= '1';
        wait for 10 ns;

        -- T1: BUS -> MAR
        CO <= '0';
        MI <= '1';
        wait for 10 ns;
        MI <= '0';

        -- T2: RAM -> BUS
        RO <= '1';
        wait for 10 ns;

        -- T3: BUS -> IR
        RO <= '0';
        II <= '1';
        wait for 10 ns;
        II <= '0';

        --------------------------------------------------
        -- STOP
        --------------------------------------------------
        wait;

    end process;

end architecture;