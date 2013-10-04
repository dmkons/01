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
    signal func : in std_logic_vector(5  downto 0);
	 signal flags : out alu_flags
);
end entity;

architecture behavioral of alu is


begin

   process(clk, x, y, func)
       
    -- used when we need a wider answer at first to determine flags
    variable r_wide : signed (32 downto 0) := (others => '0');
    -- used when we need a non-wide, but still readable answer to determine flags
    variable r_readable : signed (31 downto 0) := (others => '0');
   begin
      if rising_edge(clk) then
         case func is
				when FUNCTION_ADD =>
					r_readable := x + y;
                    r <= x + y;
					flags.overflow <= '0';
					if x(31) = y(31) and x(31) /= r_readable(31) then
						flags.overflow <= '1';
					end if;
					
				
				when FUNCTION_ADDU =>
					r_wide := ('0' & x) + ('0' & y);
					r <= x + y;
					flags.carry <= r_wide(32);
					
					
				when FUNCTION_AND =>
					r <= x and y;
					

				when FUNCTION_DIV =>
					r <= x / y;
					

				when FUNCTION_DIVU =>
					r <= signed(unsigned(x) / unsigned(y));
				

				when FUNCTION_MULT =>
					r <= resize(x * y, 32);
					

				when FUNCTION_MULTU =>
					r <= signed(unsigned(x) * unsigned(y));
					

				when FUNCTION_NOR =>
					r <= x nor y;
					

				when FUNCTION_OR =>
					r <= x or y;
					

				when FUNCTION_SLL =>
					r <= signed(shift_left(unsigned(x), to_integer(y)));
					

				when FUNCTION_SLLV =>
					r <= signed(shift_left(unsigned(x), to_integer(y)));
					

				when FUNCTION_SLT =>
					if x < y then
						r <= "00000000000000000000000000000001";
                    else
                        r <= "00000000000000000000000000000000";
					end if;
					
					
				when FUNCTION_SLTU =>
					if unsigned(x) < unsigned(y) then
						r <= "00000000000000000000000000000001";
                    else
                        r <= "00000000000000000000000000000000";
					end if;
				
				
				when FUNCTION_SRA =>
					r <= shift_right(x, to_integer(y(10 downto 6)));
					

				when FUNCTION_SRAV =>
                    r <= shift_right(x, to_integer(y));
				
					
				when FUNCTION_SRL =>
					r <= signed(shift_right(unsigned(x), to_integer(y(10 downto 6))));
					

				when FUNCTION_SRLV =>
                    r <= signed(shift_right(unsigned(x), to_integer(y)));
				

				when FUNCTION_SUB =>
					r <= x - y;
					

				when FUNCTION_SUBU =>
					r <= signed(unsigned(x) - unsigned(y));
                    flags.carry <= '0';
                    if y > x then
                        flags.carry <= '1';
                    end if;
					

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