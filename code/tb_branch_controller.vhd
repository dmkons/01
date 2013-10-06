LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.mips_constant_pkg.all;
use work.opcodes.all;
use work.test_utils.all;

 
ENTITY tb_branch_controller IS
END tb_branch_controller;
 
ARCHITECTURE behavior OF tb_branch_controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT branch_controller
    generic (
        WORD_SIZE : integer := WORD_SIZE;
        OPCODE_SIZE : integer := OPCODE_SIZE
    );
    PORT(
         flags : IN  alu_flags;
         instruction_opcode : IN  std_logic_vector(OPCODE_SIZE-1 downto 0);
         compare_zero_value : OUT  std_logic_vector(WORD_SIZE-1 downto 0);
         compare_zero : OUT  std_logic;
         branch : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal flags : alu_flags;
   signal instruction_opcode : std_logic_vector(OPCODE_SIZE-1 downto 0) := (others => '0');

 	--Outputs
   signal compare_zero_value : std_logic_vector(WORD_SIZE-1 downto 0);
   signal compare_zero : std_logic;
   signal branch : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: branch_controller PORT MAP (
          flags => flags,
          instruction_opcode => instruction_opcode,
          compare_zero_value => compare_zero_value,
          compare_zero => compare_zero,
          branch => branch
        );

   -- Clock process definitions
   clk_process :process
   begin
--		<clock> <= '0';
		wait for clk_period/2;
--		<clock> <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		

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

      wait;
   end process;

END;
