LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.mips_constant_pkg.all;
use work.opcodes.all;
 
 
ENTITY tb_alu IS
END tb_alu;
 
ARCHITECTURE behavior OF tb_alu IS 
 
    COMPONENT alu
    PORT(
         clk : IN  std_logic;
         x : IN  signed(31 downto 0);
         y : IN  signed(31 downto 0);
         r : OUT  signed(31 downto 0);
         func : IN  std_logic_vector(5 downto 0);
         flags : OUT  alu_flags
        );
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal x : signed(31 downto 0) := (others => '0');
   signal y : signed(31 downto 0) := (others => '0');
   signal func : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal r : signed(31 downto 0);
   signal flags : alu_flags;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
   uut: alu PORT MAP (
          clk => clk,
          x => x,
          y => y,
          r => r,
          func => func,
          flags => flags
        );

   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 
   stimulus_process: process
   begin		
        
      -- init waiting (is this needed?)
      wait for clk_period*10.5;
      
 
----- ADD
      func <= FUNCTION_ADD;
      -- test regular addition
      x <= "00000000000000000000000000001111";
      y <= "00000000000000000000000000000001";
      wait for clk_period;
      assert r = "00000000000000000000000000010000" report "[ADD] regular addition r should be 10000";
      assert flags.overflow = '0' report "[ADD] regular addition overflow flag should be 0";
      -- test addition that gives overflow
      x <= "01111111111111111111111111111111";
      y <= "00000000000000000000000000000001";
      wait for clk_period;
      assert r = "10000000000000000000000000000000" report "[ADD] overflow addition r should be 10000000000000000000000000000000";
      assert flags.overflow = '1' report "[ADD] carry addition overflow flag should be 1";
      -- test addition with a negative operand
      x <= "11111111111111111111111111111111";
      y <= "00000000000000000000000000000001";
      wait for clk_period;
      assert r = "10000000000000000000000000000000" report "[ADD] negative addition r should be 10000000000000000000000000000000";
      assert flags.overflow = '0' report "[ADD] negative addition overflow flag should be 0";
      
      
----- AND
      func <= FUNCTION_AND;
      

      wait;
   end process;

END;
