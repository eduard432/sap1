library ieee;
use ieee.std_logic_1164.all;

entity sap1 is
    port (
        -- Board signals:
        clk: in std_logic;
        clk_out: out std_logic;
        seg1, seg2, seg3: out std_logic_vector(6 downto 0)
        -- SAP signals in:
        -- Program Counter (PC)
        CO: in std_logic;       -- Program counter out
        J: in std_logic;        -- Jump (program counter in)
        CE: in std_logic;       -- Count enable (increment)
        -- A Register (A)
        AI: in std_logic;       -- Register in
        AO: in std_logic;       -- Register out
        -- ALU:
        EO: in std_logic;       -- Sum out
        SU: in std_logic;       -- Substract
        CY: out std_logic;      -- Carry bit (used with JC)
        -- B register (B)
        BI: in std_logic;       -- Register in
        BO: in std_logic;       -- Register out
        -- OUT (display):
        OI: in std_logic;       -- Output register in
        -- MAR (Memory Address Register)
        MI: in std_logic;       -- MAR in
        -- RAM
        RI: in std_logic;       -- RAM in
        RO: in std_logic;       -- RAN out
        -- IR (Instruction Register)
        II: in std_logic;       -- Instruction Register in
        IO: in std_logic;       -- Instruction Register out

    );
end entity sap1;

architecture bh of sap1 is
    component clock is
        generic (
            pulse: integer := 25000000  -- 1Hz
        );
        port (
            clk: in std_logic;
            manual_clk: in std_logic;
            sel: in std_logic;
            HLT: in std_logic;
            clk_out: out std_logic
        );
    end component clock;

    signal global_clk: std_logic := '0';
    signal main_bus: 

    component regs is
        generic (
            bits: integer := 8
        );
        port (
            clk   : in std_logic;
            clear : in std_logic;
            WE    : in std_logic;
            OE    : in std_logic;
            I     : in std_logic_vector(bits - 1 downto 0);
            Q     : out std_logic_vector(bits - 1 downto 0)
        );
    end component regs;

    component  program_counter is
        generic (
            bits: integer := 4
        );
        port (
            clk: in std_logic;
            reset: in std_logic;
            CE: in std_logic; -- Counter enable
            CO: in std_logic; -- Counter out
            load: in std_logic;
            data_in: in std_logic_vector(bits - 1 downto 0);
            counter: out std_logic_vector(bits - 1 downto 0)
        );
    end component program_counter;

    component ram is
        port (
            clk      : in  std_logic;
            we       : in  std_logic;
            addr     : in  std_logic_vector(7 downto 0);
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component ram;

    component output is
        port (
            bin: in std_logic(7 downto 0);
            seg1, seg2, seg3: out std_logic_vector(6 downto 0)
        );
    end component output;

    component alu is
        generic (
            bits := 8
        );
        port (
            A, B    : in  std_logic_vector(bits - 1 downto 0);
            op      : in  std_logic;
            result  : out std_logic_vector(bits - 1 downto 0);
            carry   : out std_logic
        );
    end component alu;

    signal temp_out_leds: std_logic_vector(7 downto 0);
begin
    CL0: clock
    generic map(
        25000000        
    )
    port map (
        clk => clk,
        manual_clk => '0',
        sel => '1',
        HLT => '0',
        clk_out => global_clk
    );

    clk_out <= global_clk;

    PC: program_counter
    generic map(
        4
    )
    port map (
        clk => global_clk,
        reset => not reset,
        CE => CE,
        CO => CO,
        load => not load,
        data_in => data_in,
        counter => counter
    );

    A_REGSITER: regs
    generic map (
        8
    )
    port map (
        clk => global_clk,
        clear => not clear,
        WE => not WE,
        OE => OE,
        I => I,
        Q => temp_out_leds
    );
    
    -- out_leds <= temp_out_leds when sel_leds = '1' else I;
end architecture bh;