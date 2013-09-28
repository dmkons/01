library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mips_constant_pkg.all;
use work.opcodes.all;

entity alu is
port ( 
    signal clk : in  std_logic;
    signal x : in  signed(31 downto 0);
    signal y : in  signed(31 downto 0);
    signal r : out  signed(31 downto 0);
    signal func : in std_logic_vector(6  downto 0);
	 signal flags : out alu_flags;
    signal nul : out boolean;
    signal cout : out std_logic
);
end entity;

architecture behavioral of alu is

signal r_wide : signed (32 downto 0);

begin

   process(clk)
   begin
      if rising_edge(clk) then
         case func is
				when FUNCTION_ADD =>
					r_wide <= (x(31) & x) + (y(31) & y);
					r <= r_wide(31 downto 0);
					flags.overflow <= r_wide(32);
				
				when FUNCTION_ADDU =>
					r <= x + y;
					
				when FUNCTION_AND =>
					r <= x and y;
					
				when FUNCTION_BREAK =>
					

				when FUNCTION_DIV =>
					r <= x / y;

				when FUNCTION_DIVU =>
					r <= x / y;

				when FUNCTION_JALR =>

				when FUNCTION_JR =>

				when FUNCTION_MULT =>
					r <= x * y;

				when FUNCTION_MULTU =>
					r <= x * y;

				when FUNCTION_NOR =>
					r <= x nor y;

				when FUNCTION_OR =>
					r <= x or y;

				when FUNCTION_SLL =>
					r <= shift_left(x, to_integer(y));

				when FUNCTION_SLLV =>
					r <= shift_left(x, to_integer(y));

				when FUNCTION_SLT =>
				when FUNCTION_SLTU =>
				
				when FUNCTION_SRA =>
					r <= shift_right(x, to_integer(y));

				when FUNCTION_SRAV =>
					
				when FUNCTION_SRL =>
					r <= shift_right(x, to_integer(y));

				when FUNCTION_SRLV =>

				when FUNCTION_SUB =>
					r <= x - y;

				when FUNCTION_SUBU =>
					r <= x - y;

				when FUNCTION_XOR =>
					r <= x xor y;
					
				when FUNCTION_PASSTHROUGH =>
					r <= x;
				
				when others =>
					null;
			end case;
		end if;
   end process;

end architecture;