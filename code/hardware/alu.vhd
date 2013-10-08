library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mips_constant_pkg.all;
use work.opcodes.all;

entity alu is
    generic (WORD_SIZE: natural; FUNCTION_SIZE: natural);
    port ( 
             signal x : in  signed(WORD_SIZE-1 downto 0);
             signal y : in  signed(WORD_SIZE-1 downto 0);
             signal r : out  signed(WORD_SIZE-1 downto 0);
             signal func : in std_logic_vector(FUNCTION_SIZE-1  downto 0);
             signal flags : out alu_flags
         );
end entity;

architecture Behavioral of alu is

begin

    process(x, y, func)
    -- used when we need a wider answer at first to determine flags
        variable r_wide : signed (32 downto 0) := (others => '0');
    -- used when we need a non-wide, but still readable answer to determine flags
        variable r_readable : signed (31 downto 0) := (others => '0');
    begin

        flags.carry <= '0';
        flags.overflow <= '0';
        flags.negative <= '0';
        flags.zero <= '0';
        r <= X"00000000";

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
                

                when FUNCTION_MULT =>
                    r <= resize(x * y, 32);
                    

                when FUNCTION_MULTU =>
                    r <= signed(resize(unsigned(x) * unsigned(y), 32));
                    

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
                    r_readable := x - y;
                    r <= r_readable;
                    if (r_readable="00000000000000000000000000000000") then
                        flags.zero <= '1';
                    else
                        flags.zero <= '0';
                    end if;
                    if (r_readable<"00000000000000000000000000000000") then
                        flags.negative <= '1';
                    else
                        flags.negative <= '0';
                    end if;
                    

                when FUNCTION_SUBU =>
                    r <= signed(unsigned(x) - unsigned(y));
                    flags.carry <= '0';
                    if y > x then
                        flags.carry <= '1';
                    end if;
                    

                when FUNCTION_XOR =>
                    r <= x xor y;
                    
                    
                when FUNCTION_PASSTHROUGH =>
                    r <= y;
                
                when others =>
                    null;
            end case;
   end process;

end architecture;
