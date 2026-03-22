library ieee;
use ieee.std_logic_1164.all;

entity sap1 is
    port (
        clk: in std_logic;
        bcd0, bcd1, bcd2: out std_logic_vector(3 downto 0);
        RAM_PROGRAM_DATA(7 downto 0);
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
        IO: in std_logic        -- Instruction Register out

    );
end entity sap1;

architecture bh of sap1 is

    signal global_clk: std_logic := '0';
    signal main_bus: std_logic_vector(7 downto 0) := "00000000"

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
            WE       : in  std_logic;
            OE       : in  std_logic;
            addr     : in  std_logic_vector(3 downto 0);
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component ram;

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

    component output is
        port (
            bin: in std_logic(7 downto 0);
            OI: in std_logic;
            bcd0, bcd1, bcd2: out std_logic_vector(3 downto 0)
        );
    end component output;

    signal PC_DATA, MAR_DATA: std_logic_vector(3 downto 0);
    signal A_DATA, B_DATA, ALU_DATA, RAM_DATA, IR_DATA: std_logic_vector(7 downto 0);
begin

    PC: program_counter
    generic map(
        4
    )
    port map (
        clk => clk,
        reset => '0',
        CE => CE,
        CO => CO,
        load => J,
        data_in => main_bus(3 downto 0),
        counter => PC_DATA
    );

    A_REGSITER: regs
    generic map (
        8
    )
    port map (
        clk => clk,
        clear => '0',
        WE => AI,
        OE => AO,
        I => main_bus,
        Q => A_DATA
    );
    
    ALU0: alu
    generic map (
        8    
    )
    port map (
        A => A_DATA,
        B => B_DATA,
        op => SU,
        result => ALU_DATA,
        carry => CY
    );

    B_REGSITER: regs
    generic map (
        8
    )
    port map (
        clk => clk,
        clear => '0',
        WE => BI,
        OE => BO,
        I => main_bus,
        Q => B_DATA
    );

    OUT_REGISTER: output
    port map (
        bin => main_bus,
        OI => OI,
        bcd0 => bcd0,
        bcd1 => bcd1,
        bcd2 => bcd2
    );

    MAR_REGISTER: regs
    generic map(
        4
    )
    port map (
        clk => clk,
        clear => '0',
        WE => MI,
        OE => '1',
        I => main_bus(3 downto 0),
        Q => MAR_DATA
    );

    RAM0: ram
    port map (
        clk => clk,
        WE => RI,
        OE => RO,
        addr => MAR_DATA,
        data_in => RAM_PROGRAM_DATA,
        data_out => RAM_DATA
    );

    IR: regs
    generic map(
        8
    )
    port map (
        clk => clk,
        clear => '0',
        WE => II,
        OE => IO,
        I => main_bus,
        Q => IR_DATA
    );

    -- BUS MUX:
    main_bus <= ("0000" & PC_DATA) when CO = '1' else
                A_DATA when AO = '1' else
                B_DATA when BO = '1' else
                ALU_DATA when EO = '1' else
                RAM_DATA when RO = '1' else
                ("0000" & IR_DATA(3 downto 0)) when IO = '1' else
                "00000000"

end architecture bh;