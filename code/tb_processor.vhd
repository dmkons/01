
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.mips_constant_pkg.all;
use work.opcodes.all;
use work.test_utils.all;

ENTITY tb_processor IS
END tb_processor;
 
ARCHITECTURE behavior OF tb_processor IS 
 
    COMPONENT processor
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         processor_enable : IN  std_logic;
         imem_data_in : IN  std_logic_vector(IDATA_BUS-1 downto 0);
         dmem_data_in : IN  std_logic_vector(DDATA_BUS-1 downto 0);
         imem_address : OUT  std_logic_vector(IADDR_BUS-1 downto 0);
         dmem_address : OUT  std_logic_vector(DADDR_BUS-1 downto 0);
         dmem_address_wr : OUT  std_logic_vector(DADDR_BUS-1 downto 0);
         dmem_data_out : OUT  std_logic_vector(DDATA_BUS-1 downto 0);
         dmem_write_enable : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal processor_enable : std_logic := '0';
   signal imem_data_in : std_logic_vector(IDATA_BUS-1 downto 0) := (others => '0');
   signal dmem_data_in : std_logic_vector(DDATA_BUS-1 downto 0) := (others => '0');

 	--Outputs
   signal imem_address : std_logic_vector(IADDR_BUS-1 downto 0);
   signal dmem_address : std_logic_vector(DADDR_BUS-1 downto 0);
   signal dmem_address_wr : std_logic_vector(DADDR_BUS-1 downto 0);
   signal dmem_data_out : std_logic_vector(DDATA_BUS-1 downto 0);
   signal dmem_write_enable : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: processor PORT MAP (
          clk => clk,
          reset => reset,
          processor_enable => processor_enable,
          imem_data_in => imem_data_in,
          dmem_data_in => dmem_data_in,
          imem_address => imem_address,
          dmem_address => dmem_address,
          dmem_address_wr => dmem_address_wr,
          dmem_data_out => dmem_data_out,
          dmem_write_enable => dmem_write_enable
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
      reset <= '1';
      processor_enable <= '1';
      wait for clk_period * 11;
      
      reset <= '0';
      
      -- load CAFE to R1
      imem_data_in <= OPCODE_LLI & R1 & R1 & X"CAFE";
      wait for clk_period * 2;
      
      -- load BABE to R2
      imem_data_in <= OPCODE_LLI & R2 & R2 & X"BABE";
      wait for clk_period * 2;
      
      -- logically shift CAFE to the left by 16
      imem_data_in <= OPCODE_R_ALL & R1 & R1 & R1 & "10000" & FUNCTION_SLL;
      wait for clk_period * 2;
      
      -- OR together CAFE and BABE
      imem_data_in <= OPCODE_R_ALL & R1 & R2 & R3 & "00000" & FUNCTION_OR;
      wait for clk_period * 2;
     
      -- store CAFEBABE to address 0
      imem_data_in <= OPCODE_SW & R0 & R3 & "0000000000000001";
      wait for clk_period*1.5;
      test("cafebabe", "dmem write enable", dmem_write_enable, '1');
      test("cafebabe", "address", dmem_address_wr, "00000001");
      test("cafebabe", "data", dmem_data_out, X"CAFEBABE");
      wait for clk_period*0.5;
      

      

      wait;
   end process;

END;
