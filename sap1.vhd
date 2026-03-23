library ieee;
use ieee.std_logic_1164.all;

entity sap1 is
    port (
        clk_in: in std_logic;
        clk_out: out std_logic;
        seg0, seg1, seg2: out std_logic_vector(6 downto 0);
        RAM_PROGRAM_DATA: in std_logic_vector(7 downto 0);
        reset_in: in std_logic;
        bus_out: out std_logic_vector(7 downto 0);
        -- ALU:
        CY: out std_logic      -- Carry bit (used with JC)

    );
end entity sap1;

architecture bh of sap1 is
    signal main_bus: std_logic_vector(7 downto 0) := "00000000";

    component clock is
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
    end component clock;


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

    component alu is
        generic (
            bits: integer := 8
        );
        port (
            A, B    : in  std_logic_vector(bits - 1 downto 0);
            op      : in  std_logic;
            result  : out std_logic_vector(bits - 1 downto 0);
            carry   : out std_logic
        );
    end component alu;

    component output_disp is
        port (
            bin: in std_logic_vector(7 downto 0);
            OI: in std_logic;
            seg0, seg1, seg2: out std_logic_vector(6 downto 0)
        );
    end component output_disp;
	 
	 component ram_ip is
		port
		(
			address		: in STD_LOGIC_VECTOR (7 downto 0);
			clock		: in STD_LOGIC  := '1';
			data		: in STD_LOGIC_VECTOR (7 downto 0);
			wren		: in STD_LOGIC ;
			q		: out STD_LOGIC_VECTOR (7 downto 0)
		);
	end component ram_ip;

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

    component control_unit is
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
    end component control_unit;

    signal HALT_s, CO_s, J_s, CE_s, AI_s, AO_s, EO_s, SU_s, BI_s, BO_s, OI_s, MI_s, RI_s, RO_s, II_s, IO_s: std_logic;

    signal PC_DATA, MAR_DATA: std_logic_vector(3 downto 0);
    signal A_DATA, B_DATA, ALU_DATA, RAM_DATA, IR_DATA: std_logic_vector(7 downto 0);
	 
	signal clk: std_logic;
    signal reset: std_logic;
begin

    reset <= not reset_in;

    CLK0: clock
    generic map(
        pulse => 20000000 -- 50Mhz to 1Hz
    )
    port map (
        clk => clk_in,
        manual_clk => '0',
        sel => '1',
        HLT => HALT_s,
        clk_out => clk
    );

    clk_out <= clk;

    CU: control_unit
    port map (
        clk => clk,
        reset => reset,
        opcode => IR_DATA(7 downto 4),
        HALT => HALT_s,	    -- Stop
        -- Program Counter (PC)
        CO => CO_s,       -- Program counter out
        J => J_s,        -- Jump (program counter in)
        CE => CE_s,       -- Count enable (increment)
        -- A Register (A)
        AI => AI_s,       -- Register in
        AO => AO_s,       -- Register out
        -- ALU:
        EO => EO_s,       -- Sum out
        SU => SU_s,       -- Substract
        -- B register (B)
        BI => BI_s,       -- Register in
        BO => BO_s,       -- Register out
        -- OUT (display):
        OI => OI_s,       -- Output register in
        -- MAR (Memory Address Register)
        MI => MI_s,       -- MAR in
        -- RAM
        RI => RI_s,       -- RAM in
        RO => RO_s,       -- RAN out
        -- IR (Instruction Register)
        II => II_s,       -- Instruction Register in
        IO => IO_s        -- Instruction Register out
    );

    PC: program_counter
    generic map(
        4
    )
    port map (
        clk => clk,
        reset => reset,
        CE => CE_s,
        CO => CO_s,
        load => J_s,
        data_in => main_bus(3 downto 0),
        counter => PC_DATA
    );

    A_REGSITER: regs
    generic map (
        8
    )
    port map (
        clk => clk,
        clear => reset,
        WE => AI_s,
        OE => AO_s,
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
        op => SU_s,
        result => ALU_DATA,
        carry => CY
    );

    B_REGSITER: regs
    generic map (
        8
    )
    port map (
        clk => clk,
        clear => reset,
        WE => BI_s,
        OE => BO_s,
        I => main_bus,
        Q => B_DATA
    );

    OUT_REGISTER: output_disp
    port map (
        bin => main_bus,
        OI => OI_s,
        seg0 => seg0,
        seg1 => seg1,
        seg2 => seg2
    );

    MAR_REGISTER: regs
    generic map(
        4
    )
    port map (
        clk => clk,
        clear => reset,
        WE => MI_s,
        OE => '1',
        I => main_bus(3 downto 0),
        Q => MAR_DATA
    );

    -- RAM0: ram
    -- port map (
    --     clk => clk,
    --     WE => RI_s,
    --     OE => RO_s,
    --     addr => MAR_DATA,
    --     data_in => RAM_PROGRAM_DATA,
    --     data_out => RAM_DATA
    -- );

    ram_ip_inst : ram_ip 
    port map (
		clock	 => clk,
		wren	 => RI_s,
		address	 => "0000" & MAR_DATA,
		data	 => RAM_PROGRAM_DATA,
		q	 => RAM_DATA
	);

    IR: regs
    generic map(
        8
    )
    port map (
        clk => clk,
        clear => reset,
        WE => II_s,
        OE => IO_s,
        I => main_bus,
        Q => IR_DATA
    );

    bus_out <= main_bus;

    -- BUS MUX:
    main_bus <= ("0000" & PC_DATA) when CO_s = '1' else
                A_DATA when AO_s = '1' else
                B_DATA when BO_s = '1' else
                ALU_DATA when EO_s = '1' else
                RAM_DATA when RO_s = '1' else
                ("0000" & IR_DATA(3 downto 0)) when IO_s = '1' else
                "00000000";

end architecture bh;