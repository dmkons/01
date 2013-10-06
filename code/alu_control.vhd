library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.opcodes.all;

entity alu_control is
    generic( FUNCTION_SIZE: natural);
    Port ( func : in std_logic_vector(FUNCTION_SIZE-1 downto 0);
			  alu_operation : in std_logic;
              output : out  std_logic_vector(FUNCTION_SIZE-1 downto 0)
	 );
end alu_control;

architecture behavioral of alu_control is
begin

process(func)
begin

	if alu_operation = '1' then
		output <= func;
	else
		output <= FUNCTION_PASSTHROUGH;
	end if;

end process;

end behavioral;

