
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.mips_constant_pkg.all;
 
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
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      
      reset <= '1';
      wait for clk_period * 5.5;	
      reset <= '0';
      processor_enable <= '1';
      imem_data_in <= "00000000000000000000000000100000";
      
      wait for clk_period * 3;

      

      wait;
   end process;

END;
