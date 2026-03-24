library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port (
        clk: in std_logic;
        reset: in std_logic;
        opcode: in std_logic_vector(3 downto 0);
        HALT: out std_logic;	    -- Stop
        -- Program Counter (PC)
        CO: out std_logic;       -- Program counter out
        J: out std_logic;        -- Jump (program counter in)
        CE: out std_logic;       -- Count enable (increment)
        -- A Register (A)
        AI: out std_logic;       -- Register in
        AO: out std_logic;       -- Register out
        -- ALU:
        EO: out std_logic;       -- Sum out
        SU: out std_logic;       -- Substract
        -- B register (B)
        BI: out std_logic;       -- Register in
        BO: out std_logic;       -- Register out
        -- OUT (display):
        OI: out std_logic;       -- Output register in
        -- MAR (Memory Address Register)
        MI: out std_logic;       -- MAR in
        -- RAM
        RI: out std_logic;       -- RAM in
        RO: out std_logic;       -- RAN out
        -- IR (Instruction Register)
        II: out std_logic;       -- Instruction Register in
        IO: out std_logic        -- Instruction Register out
    );
end entity control_unit;

architecture bh of control_unit is
    type state_type is (T0, T1, T2, T3, T4);
    signal state: state_type:= T0;
    signal next_state: state_type;

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= T0;
            else
                state <= next_state;
            end if; 
        end if;
    end process;
    

    process(state)
    begin
        case state is
            when T0 => next_state <= T1;
            when T1 => next_state <= T2;
            when T2 => next_state <= T3;
            when T3 => next_state <= T4;
            when T4 => next_state <= T0;
        end case;
    end process;

    process(state, opcode)
    begin
        -- default
        CO <= '0';
        J <= '0';
        CE <= '0';
        AI <= '0';
        AO <= '0';
        EO <= '0';
        SU <= '0';
        BI <= '0';
        BO <= '0';
        OI <= '0';
        MI <= '0';
        RI <= '0';
        RO <= '0';
        II <= '0';
        IO <= '0';

        case state is
            when T0 =>
                CO <= '1';
                MI <= '1';

            when T1 =>
                RO <= '1';
                II <= '1';
                CE <= '1';

            when T2 =>
                case opcode is
                    when "0001" => -- LDA
                        IO <= '1';
                        MI <= '1';

                    when "0010" => -- ADD
                        IO <= '1';
                        MI <= '1';

                    when "1110" => -- OUT
                        AO <= '1';
                        OI <= '1';

                    when others =>
                        null;
                end case;

            when T3 =>
                case opcode is
                    when "0001" => -- LDA
                        RO <= '1';
                        AI <= '1';

                    when "0010" => -- ADD
                        RO <= '1';
                        BI <= '1';

                    when others =>
                        null;
                end case;

            when T4 => 
                case opcode is
                    when "0010" => -- ADD
                        EO <= '1';
                        AI <= '1';
                    when others =>
                        null;
                end case;
        end case;
    end process;
end architecture bh;