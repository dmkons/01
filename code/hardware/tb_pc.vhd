LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.mips_constant_pkg.all;
use work.opcodes.all;
use work.test_utils.all;

 
ENTITY tb_pc IS
END tb_pc;
 
ARCHITECTURE behavior OF tb_pc IS 

   --Inputs
   signal clk : std_logic := '0';
   signal pc_in : std_logic_vector(IDATA_BUS-1 downto 0) := (others => '0');
   signal reset : std_logic := '0';
   signal pc_enable : std_logic := '0';

 	--Outputs
   signal pc_out : std_logic_vector(IDATA_BUS-1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.pc
   generic map (n => IDATA_BUS)
   PORT MAP (
          clk => clk,
          pc_in => pc_in,
          reset => reset,
          pc_enable => pc_enable,
          pc_out => pc_out
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
        pc_in <= "00000000000000000000000000000001";   
        reset <= '0';
        pc_enable <= '0';
        wait for clk_period*10.5;
        
        -- Test that reset does not load new a pc value
        reset <= '1';
        pc_enable <= '0';
        wait for clk_period*1;
        test("NOLOAD", "pc no load", pc_out, "00000000000000000000000000000000");
        
        -- Test that the signal is stay unchanged with pc_enable = 0
        reset <= '0';
        pc_enable <= '0';
        wait for clk_period*1;
        test("NOTENABLED", "pc not enabled", pc_out, "00000000000000000000000000000000");
        
        -- Test that the pc will update its vaule
        reset <= '0';
        pc_enable <= '1';
        wait for clk_period*1;
        test("ENABLED", "pc enabled", pc_out, "00000000000000000000000000000001");
        
        -- Test that the reset will acctually reset an existing vaule
        reset <= '1';
        pc_enable <= '1';
        wait for clk_period*1;
        test("RESET", "pc reset", pc_out, "00000000000000000000000000000000");

      wait;
   end process;

END;
