library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mips_constant_pkg.all;
use work.opcodes.all;
use work.test_utils.all;

entity tb_branch_controller is
    end tb_branch_controller;

architecture behavior of tb_branch_controller is 

   --Inputs
    signal flags : alu_flags;
    signal instruction_opcode : std_logic_vector(OPCODE_SIZE-1 downto 0) := (others => '0');

   --Outputs
    signal compare_zero_value : std_logic_vector(WORD_SIZE-1 downto 0);
    signal compare_zero : std_logic;
    signal branch : std_logic;

    constant clk_period : time := 10 ns;

begin

   -- Instantiate the Unit Under Test (UUT)
    uut: entity work.branch_controller 
    generic map (
                    WORD_SIZE => WORD_SIZE,
                    OPCODE_SIZE => OPCODE_SIZE
                )
    port map (
                 flags => flags,
                 instruction_opcode => instruction_opcode,
                 compare_zero_value => compare_zero_value,
                 compare_zero => compare_zero,
                 branch => branch
             );

   -- Clock process definitions
    clk_process :process
    begin
        wait for clk_period/2;
        wait for clk_period/2;
    end process;


   -- Stimulus process
    stim_proc: process
    begin		

      -- Allow the component to settle
        wait for clk_period*10.5;

      -- Test branch when equals
        instruction_opcode <= OPCODE_BEQ;

        flags.zero <= '0';
        flags.negative <= '0';
        wait for clk_period;
        test("BEQ", "not equal (branach)", branch, '0');
        test("BEQ", "not equal (compare_zero)", compare_zero, '0');
        test("BEQ", "not equal (compare_zero_value)", compare_zero_value, "00000000000000000000000000000000");

        flags.zero <= '1';
        flags.negative <= '0';
        wait for clk_period;
        test("BEQ", "equal (branach)", branch, '1');
        test("BEQ", "equal (compare_zero)", compare_zero, '0');
        test("BEQ", "equal (compare_zero_value)", compare_zero_value, "00000000000000000000000000000000");

        -- Test branch when greater than or equal to zero
        instruction_opcode <= OPCODE_BGEZ;

        flags.zero <= '0';
        flags.negative <= '0';
        wait for clk_period;
        test("BGEZ", "greater (branach)", branch, '1');
        test("BGEZ", "greater (compare_zero)", compare_zero, '1');
        test("BGEZ", "greater (compare_zero_value)", compare_zero_value, "00000000000000000000000000000000");

        flags.zero <= '0';
        flags.negative <= '1';
        wait for clk_period;
        test("BGEZ", "greater (branach)", branch, '0');
        test("BGEZ", "greater (compare_zero)", compare_zero, '1');
        test("BGEZ", "greater (compare_zero_value)", compare_zero_value, "00000000000000000000000000000000");

        -- Test branch when greater than zero
        instruction_opcode <= OPCODE_BGTZ;

        flags.zero <= '0';
        flags.negative <= '0';
        wait for clk_period;
        test("BGTZ", "greater (branach)", branch, '1');
        test("BGTZ", "greater (compare_zero)", compare_zero, '1');
        test("BGTZ", "greater (compare_zero_value)", compare_zero_value, "00000000000000000000000000000001");

        flags.zero <= '0';
        flags.negative <= '1';
        wait for clk_period;
        test("BGTZ", "greater (branach)", branch, '0');
        test("BGTZ", "greater (compare_zero)", compare_zero, '1');
        test("BGTZ", "greater (compare_zero_value)", compare_zero_value, "00000000000000000000000000000001");

        -- Test branch when less than or equal to zero
        instruction_opcode <= OPCODE_BLEZ;

        flags.zero <= '0';
        flags.negative <= '0';
        wait for clk_period;
        test("BGEZ", "greater (branach)", branch, '0');
        test("BGEZ", "greater (compare_zero)", compare_zero, '1');
        test("BGEZ", "greater (compare_zero_value)", compare_zero_value, "11111111111111111111111111111111");

        flags.zero <= '0';
        flags.negative <= '1';
        wait for clk_period;
        test("BGEZ", "greater (branach)", branch, '1');
        test("BGEZ", "greater (compare_zero)", compare_zero, '1');
        test("BGEZ", "greater (compare_zero_value)", compare_zero_value, "11111111111111111111111111111111");

        -- Test branch when not equals
        instruction_opcode <= OPCODE_BNE;

        flags.zero <= '0';
        flags.negative <= '0';
        wait for clk_period;
        test("BNE", "not equal (branach)", branch, '1');
        test("BNE", "not equal (compare_zero)", compare_zero, '0');
        test("BNE", "not equal (compare_zero_value)", compare_zero_value, "00000000000000000000000000000000");

        flags.zero <= '1';
        flags.negative <= '0';
        wait for clk_period;
        test("BNE", "equal (branach)", branch, '0');
        test("BNE", "equal (compare_zero)", compare_zero, '0');
        test("BNE", "equal (compare_zero_value)", compare_zero_value, "00000000000000000000000000000000");

      -- end of tests

        wait;
    end process;

end;
