library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mips_constant_pkg.all;
use work.opcodes.all;
use work.test_utils.all;

entity tb_control_unit is
    end tb_control_unit;

architecture behavior of tb_control_unit is 

   --Inputs
    signal clock : std_logic := '0';
    signal instruction_opcode : std_logic_vector(5 downto 0) := (others => '0');
    signal instruction_func : std_logic_vector(5 downto 0) := (others => '0');
    signal processor_enable : std_logic := '0';
    signal reset : std_logic := '0';

   --Outputs
    signal register_destination : std_logic;
    signal memory_to_register : std_logic;
    signal alu_func : std_logic_vector(5 downto 0);
    signal memory_write : std_logic;
    signal alu_source : std_logic;
    signal register_write : std_logic;
    signal pc_enable : std_logic;
    signal jump : std_logic;
    signal shift_swap : std_logic;

   -- Clock period definitions
    constant clock_period : time := 10 ns;

begin

   -- Instantiate the Unit Under Test (UUT)
    uut: entity work.control_unit 
    generic map (
                    OPCODE_SIZE => OPCODE_SIZE,
                    FUNCTION_SIZE => FUNCTION_SIZE
                )
    port map (
                 clock => clock,
                 instruction_opcode => instruction_opcode,
                 instruction_func => instruction_func,
                 processor_enable => processor_enable,
                 reset => reset,
                 register_destination => register_destination,
                 memory_to_register => memory_to_register,
                 alu_func => alu_func,
                 memory_write => memory_write,
                 alu_source => alu_source,
                 register_write => register_write,
                 pc_enable => pc_enable,
                 jump => jump,
                 shift_swap => shift_swap
             );

   -- Clock process definitions
    clock_process :process
    begin
        clock <= '1';
        wait for clock_period/2;
        clock <= '0';
        wait for clock_period/2;
    end process;


   -- Stimulus process
    stim_proc: process
    begin		
             -- hold reset state for 100 ns.




             -- Test state machine fetch -> execute(add) -> fetch -> execute(add) -> fetch
        processor_enable <= '1';
        reset <= '1';
        wait for clock_period*10;
        reset <= '0';
        instruction_opcode <= OPCODE_R_all;
        instruction_func <= FUNCTION_ADD;
        wait for clock_period*3;
        wait for clock_period*0.5;
        test("EXE1", "execute add register_destination", register_destination, '1');
        test("EXE1", "execute add memory_to_register", memory_to_register, '0');
        test("EXE1", "execute add memory_write", memory_write, '0');
        test("EXE1", "execute add alu_source", alu_source, '0');
        test("EXE1", "execute add register_write", register_write, '1');
        test("EXE1", "execute add shift_swap", shift_swap, '0');
        test("EXE1", "execute add jump", jump, '0');
        test("EXE1", "execute add pc_enable", pc_enable, '1');
        test("EXE1", "execute add alu_func", alu_func, FUNCTION_ADD);       
        wait for clock_period*0.5;
        wait for clock_period;
        wait for clock_period*0.5;
        test("EXE2", "execute add register_destination", register_destination, '1');
        test("EXE2", "execute add memory_to_register", memory_to_register, '0');
        test("EXE2", "execute add memory_write", memory_write, '0');
        test("EXE2", "execute add alu_source", alu_source, '0');
        test("EXE2", "execute add register_write", register_write, '1');
        test("EXE2", "execute add shift_swap", shift_swap, '0');
        test("EXE2", "execute add jump", jump, '0');
        test("EXE2", "execute add pc_enable", pc_enable, '1');
        test("EXE2", "execute add alu_func", alu_func, FUNCTION_ADD);
        wait for clock_period*0.5;

         -- Test state machine fetch -> execute lw -> stall -> fetch -> execute lw
        processor_enable <= '1';
        reset <= '1';
        wait for clock_period;
        reset <= '0';
        instruction_opcode <= OPCODE_LW;
        instruction_func <= FUNCTION_PASSTHROUGH;
        wait for clock_period;

        wait for clock_period*0.5;
        test("EXE3", "execute lw register_destination", register_destination, '0');
        test("EXE3", "execute lw memory_to_register", memory_to_register, '1');
        test("EXE3", "execute lw memory_write", memory_write, '0');
        test("EXE3", "execute lw alu_source", alu_source, '1');
        test("EXE3", "execute lw register_write", register_write, '1');
        test("EXE3", "execute lw shift_swap", shift_swap, '0');
        test("EXE3", "execute lw jump", jump, '0');
        test("EXE3", "execute lw pc_enable", pc_enable, '0');
        test("EXE3", "execute lw alu_func", alu_func, FUNCTION_PASSTHROUGH);
        wait for clock_period;
        test("EXE4", "execute lw register_destination", register_destination, '0');
        test("EXE4", "execute lw memory_to_register", memory_to_register, '0');
        test("EXE4", "execute lw memory_write", memory_write, '0');
        test("EXE4", "execute lw alu_source", alu_source, '0');
        test("EXE4", "execute lw register_write", register_write, '0');
        test("EXE4", "execute lw shift_swap", shift_swap, '0');
        test("EXE4", "execute lw jump", jump, '0');
        test("EXE4", "execute lw pc_enable", pc_enable, '1');
        test("EXE4", "execute lw alu_func", alu_func, FUNCTION_PASSTHROUGH);
        wait for clock_period;
        test("EXE5", "execute lw register_destination", register_destination, '0');
        test("EXE5", "execute lw memory_to_register", memory_to_register, '0');
        test("EXE5", "execute lw memory_write", memory_write, '0');
        test("EXE5", "execute lw alu_source", alu_source, '0');
        test("EXE5", "execute lw register_write", register_write, '0');
        test("EXE5", "execute lw shift_swap", shift_swap, '0');
        test("EXE5", "execute lw jump", jump, '0');
        test("EXE5", "execute lw pc_enable", pc_enable, '0');
        test("EXE5", "execute lw alu_func", alu_func, FUNCTION_PASSTHROUGH);
        wait for clock_period*0.5;

            -- Test that OPCODE_ADDI | OPCODE_ADDIU | OPCODE_ANDI | OPCODE_ORI 
            -- | OPCODE_XORI | OPCODE_LUI | OPCODE_SLTI | OPCODE_SLTIU => 
            -- alu_source = register_write = 1					

        processor_enable <= '1';
        reset <= '1';
        wait for clock_period;
        reset <= '0';
        instruction_opcode <= OPCODE_ADDI;
        instruction_func <= FUNCTION_PASSTHROUGH;
        wait for clock_period;
        wait for clock_period*0.5;
        test("ADDI", "execute ADDI register_destination", register_destination, '0');
        test("ADDI", "execute ADDI memory_to_register", memory_to_register, '0');
        test("ADDI", "execute ADDI memory_write", memory_write, '0');
        test("ADDI", "execute ADDI alu_source", alu_source, '1');
        test("ADDI", "execute ADDI register_write", register_write, '1');
        test("ADDI", "execute ADDI shift_swap", shift_swap, '0');
        test("ADDI", "execute ADDI jump", jump, '0');
        test("ADDI", "execute ADDI pc_enable", pc_enable, '1');
        test("ADDI", "execute ADDI alu_func", alu_func, FUNCTION_ADD);
        wait for clock_period*0.5;


            -- Test that OPCODE_BEQ | OPCODE_BGEZ | OPCODE_BGTZ  | OPCODE_BLEZ  
            -- | OPCODE_BNE => alu_func = FUNCTION_SUB

        processor_enable <= '1';
        reset <= '1';
        wait for clock_period;
        reset <= '0';
        instruction_opcode <= OPCODE_BEQ;
        instruction_func <= FUNCTION_PASSTHROUGH;
        wait for clock_period;
        wait for clock_period*0.5;
        test("BEQ", "execute BEQ register_destination", register_destination, '0');
        test("BEQ", "execute BEQ memory_to_register", memory_to_register, '0');
        test("BEQ", "execute BEQ memory_write", memory_write, '0');
        test("BEQ", "execute BEQ alu_source", alu_source, '0');
        test("BEQ", "execute BEQ register_write", register_write, '0');
        test("BEQ", "execute BEQ shift_swap", shift_swap, '0');
        test("BEQ", "execute BEQ jump", jump, '0');
        test("BEQ", "execute BEQ pc_enable", pc_enable, '1');
        test("BEQ", "execute BEQ alu_func", alu_func, FUNCTION_SUB);

        wait for clock_period*0.5;

            -- Test OPCODE_LW => memory_to_register = alu_source = register_write = 1
            -- and pc_enable = 0

        processor_enable <= '1';
        reset <= '1';
        wait for clock_period;
        reset <= '0';
        instruction_opcode <= OPCODE_LW;
        instruction_func <= FUNCTION_PASSTHROUGH;
        wait for clock_period;
        wait for clock_period*0.5;
        test("LW", "execute LW register_destination", register_destination, '0');
        test("LW", "execute LW memory_to_register", memory_to_register, '1');
        test("LW", "execute LW memory_write", memory_write, '0');
        test("LW", "execute LW alu_source", alu_source, '1');
        test("LW", "execute LW register_write", register_write, '1');
        test("LW", "execute LW shift_swap", shift_swap, '0');
        test("LW", "execute LW jump", jump, '0');
        test("LW", "execute LW pc_enable", pc_enable, '0');
        test("LW", "execute LW alu_func", alu_func, FUNCTION_PASSTHROUGH);
        wait for clock_period*0.5;

            -- Test OPCODE_SW => memory_write = alu_source = 1 and pc_enable = 0

        processor_enable <= '1';
        reset <= '1';
        wait for clock_period;
        reset <= '0';
        instruction_opcode <= OPCODE_SW;
        instruction_func <= FUNCTION_PASSTHROUGH;
        wait for clock_period;
        wait for clock_period*0.5;
        test("SW", "execute SW register_destination", register_destination, '0');
        test("SW", "execute SW memory_to_register", memory_to_register, '0');
        test("SW", "execute SW memory_write", memory_write, '1');
        test("SW", "execute SW alu_source", alu_source, '1');
        test("SW", "execute SW register_write", register_write, '0');
        test("SW", "execute SW shift_swap", shift_swap, '0');
        test("SW", "execute SW jump", jump, '0');
        test("SW", "execute SW pc_enable", pc_enable, '0');
        test("SW", "execute SW alu_func", alu_func, FUNCTION_PASSTHROUGH);
        wait for clock_period*0.5;

            -- Test OPCODE_J => jump = 1

        processor_enable <= '1';
        reset <= '1';
        wait for clock_period;
        reset <= '0';
        instruction_opcode <= OPCODE_J;
        instruction_func <= FUNCTION_PASSTHROUGH;
        wait for clock_period;
        wait for clock_period*0.5;
        test("J", "execute J register_destination", register_destination, '0');
        test("J", "execute J memory_to_register", memory_to_register, '0');
        test("J", "execute J memory_write", memory_write, '0');
        test("J", "execute J alu_source", alu_source, '0');
        test("J", "execute J register_write", register_write, '0');
        test("J", "execute J shift_swap", shift_swap, '0');
        test("J", "execute J jump", jump, '1');
        test("J", "execute J pc_enable", pc_enable, '1');
        test("J", "execute J alu_func", alu_func, FUNCTION_PASSTHROUGH);
        wait for clock_period*0.5;

            -- Test R_all & instruction_function != FUNCTION_SLL | FUNCTION_SRL => 
            -- register_destination = register_write = 1 and shift_swap = 0
        processor_enable <= '1';
        reset <= '1';
        wait for clock_period;
        reset <= '0';
        instruction_opcode <= OPCODE_R_all;
        instruction_func <= FUNCTION_ADD;
        wait for clock_period;
        wait for clock_period*0.5;
        test("all!SH", "execute ADD and no shift register_destination", register_destination, '1');
        test("all!SH", "execute ADD and no shift memory_to_register", memory_to_register, '0');
        test("all!SH", "execute ADD and no shift memory_write", memory_write, '0');
        test("all!SH", "execute ADD and no shift alu_source", alu_source, '0');
        test("all!SH", "execute ADD and no shift register_write", register_write, '1');
        test("all!SH", "execute ADD and no shift shift_swap", shift_swap, '0');
        test("all!SH", "execute ADD and no shift jump", jump, '0');
        test("all!SH", "execute ADD and no shift pc_enable", pc_enable, '1');
        test("all!SH", "execute ADD and no shift alu_func", alu_func, FUNCTION_ADD);
        wait for clock_period*0.5;

            -- Test R_all & instruction_function = FUNCTION_SLL | FUNCTION_SRL => 
            -- register_destination = register_write = shift_swap = 1
        processor_enable <= '1';
        reset <= '1';
        wait for clock_period;
        reset <= '0';
        instruction_opcode <= OPCODE_R_all;
        instruction_func <= FUNCTION_SLL;
        wait for clock_period;
        wait for clock_period*0.5;
        test("allSH", "execute ADD and shift register_destination", register_destination, '1');
        test("allSH", "execute ADD and shift memory_to_register", memory_to_register, '0');
        test("allSH", "execute ADD and shift memory_write", memory_write, '0');
        test("allSH", "execute ADD and shift alu_source", alu_source, '0');
        test("allSH", "execute ADD and shift register_write", register_write, '1');
        test("allSH", "execute ADD and shift shift_swap", shift_swap, '1');
        test("allSH", "execute ADD and shift jump", jump, '0');
        test("allSH", "execute ADD and shift pc_enable", pc_enable, '1');
        test("allSH", "execute ADD and shift alu_func", alu_func, FUNCTION_SLL);
        wait for clock_period*0.5;

        wait;
    end process;

end;
