
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.opcodes.all;
use work.mips_constant_pkg.all;
 
ENTITY t_control_unit IS
END t_control_unit;
 
ARCHITECTURE behavior OF t_control_unit IS 
 
    COMPONENT control_unit
    generic (
        OPCODE_SIZE : integer := OPCODE_SIZE;
        FUNCTION_SIZE : integer := FUNCTION_SIZE
    );
    PORT(
         clock : IN  std_logic;
         instruction_opcode : IN  std_logic_vector(OPCODE_SIZE-1 downto 0);
         instruction_func : IN  std_logic_vector(FUNCTION_SIZE-1 downto 0);
         reset : IN  std_logic;
         register_destination : OUT  std_logic;
         branch : OUT  std_logic;
         memory_to_register : OUT  std_logic;
         alu_func : OUT  std_logic_vector(FUNCTION_SIZE-1 downto 0);
         memory_write : OUT  std_logic;
         alu_source : OUT  std_logic;
         register_write : OUT  std_logic;
         jump : OUT  std_logic;
         shift_swap : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal instruction_opcode : std_logic_vector(OPCODE_SIZE-1 downto 0) := (others => '0');
   signal instruction_func : std_logic_vector(FUNCTION_SIZE-1 downto 0) := (others => '0');
   signal reset : std_logic := '0';

 	--Outputs
   signal register_destination : std_logic;
   signal branch : std_logic;
   signal memory_to_register : std_logic;
   signal alu_func : std_logic_vector(FUNCTION_SIZE-1 downto 0);
   signal memory_write : std_logic;
   signal alu_source : std_logic;
   signal register_write : std_logic;
   signal jump : std_logic;
   signal shift_swap : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
   uut: control_unit PORT MAP (
          clock => clock,
          instruction_opcode => instruction_opcode,
          instruction_func => instruction_func,
          reset => reset,
          register_destination => register_destination,
          branch => branch,
          memory_to_register => memory_to_register,
          alu_func => alu_func,
          memory_write => memory_write,
          alu_source => alu_source,
          register_write => register_write,
          jump => jump,
          shift_swap => shift_swap
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      reset <= '1';
      wait for 5.5 * clock_period;
      reset <= '0';

      instruction_opcode <= OPCODE_R_ALL;
      instruction_func <= FUNCTION_AND;
      
      wait for 2 * clock_period;
      
      instruction_opcode <= OPCODE_LDI;
      
      wait;
   end process;

END;
