LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.mips_constant_pkg.all;
use work.opcodes.all;
use work.test_utils.all;
 
ENTITY tb_mux IS
END tb_mux;
 
ARCHITECTURE behavior OF tb_mux IS 

   --Inputs
   signal mux_enable : std_logic := '0';
   signal mux_in_0 : std_logic_vector(31 downto 0) := (others => '0');
   signal mux_in_1 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal mux_out : std_logic_vector(31 downto 0);

   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.mux 
       generic map (n => 32)
       PORT MAP (
          mux_enable => mux_enable,
          mux_in_0 => mux_in_0,
          mux_in_1 => mux_in_1,
          mux_out => mux_out
        );

   -- Stimulus process
   stim_proc: process
   begin
      wait for clk_period*10.5;
        
        -- Test that the input 0 passes zero values
      mux_enable <= '0';
      mux_in_0 <= "00000000000000000000000000000000";
      mux_in_1 <= "00000000000000000000000000000001";
      wait for clk_period;
      test("DISABLED1", "mux disabled with first input data", mux_out, "00000000000000000000000000000000");
      
      -- Test that the input 1 passes non zero values
      mux_enable <= '1';
      mux_in_0 <= "00000000000000000000000000000000";
      mux_in_1 <= "00000000000000000000000000000001";
      wait for clk_period;
      test("ENABLED1", "mux enabled with first input data", mux_out, "00000000000000000000000000000001");
      
      -- Test that the input 0 passes non zero values
      mux_enable <= '0';
      mux_in_0 <= "00000000000000000000000000000001";
      mux_in_1 <= "00000000000000000000000000000000";
      wait for clk_period;
      test("DISABLED2", "mux disabled with second input data", mux_out, "00000000000000000000000000000001");
      
      -- Test that the input 1 passes zero values
      mux_enable <= '1';
      mux_in_0 <= "00000000000000000000000000000001";
      mux_in_1 <= "00000000000000000000000000000000";
      wait for clk_period;
      test("ENABLED2", "mux enabled with second input data", mux_out, "00000000000000000000000000000000");
      
      wait;
   end process;

END;
